//
//  GetDetailPresenter.swift
//  Detail
//
//  Created by Mochamad Ikhsan Nurdiansyah on 23/03/25.
//

import Combine
import SwiftUI
import Core
import Category
import Favorites

public class GetDetailPresenter<Request, Response, Interactor: UseCase>: ObservableObject
where Interactor.Request == Request, Interactor.Response == Response {
    
    private let _useCase: Interactor
    private let favoriteRepository: GetFavoritesRepository<GetFavoriteLocaleDataSource, GetFavoriteRemoteDataSource>
    private var cancellables: Set<AnyCancellable> = []
    
    @Published public var movie: Response?
    @Published public var isLoading: Bool = false
    @Published public var error: String?
    @Published public var isFavorite: Bool = false
    
    private var movieId: Request?
    
    public init(movieId: Request, useCase: Interactor, favoriteRepository: GetFavoritesRepository<GetFavoriteLocaleDataSource, GetFavoriteRemoteDataSource>) {
        self.movieId = movieId
        self._useCase = useCase
        self.favoriteRepository = favoriteRepository
    }
    
    public func getMovieDetail() {
        guard let movieId = movieId else { return }
        
        isLoading = true
        error = nil
        
        _useCase.execute(request: movieId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.error = error.localizedDescription
                    print("Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { movie in
                self.movie = movie
                self.isFavorite = (movie as? CategoryDomainModel)?.isFavorite ?? false
                print("Detail Movie: \(String(describing: movie))") 
            })
            .store(in: &cancellables)
    }
    
    @MainActor
    public func toggleFavoriteStatus() {
        guard var movie = movie as? CategoryDomainModel else {
            print("❌ Error: Movie data is nil or not a CategoryDomainModel")
            return
        }

        let newStatus = !movie.isFavorite
        print("🔄 Before toggle: \(movie.isFavorite) -> After toggle: \(newStatus)")

        movie.isFavorite = newStatus
        self.isFavorite = newStatus
        self.movie = movie as? Response

        let context = CoreDataManager.shared.persistentContainer.viewContext
        guard let movieEntity = FavoriteTransformer.transformDomainToEntity(domain: movie, context: context) else {
            print("❌ Error: Failed to convert CategoryDomainModel to MoviesEntity")
            return
        }

        favoriteRepository.updateFavoriteStatus(for: movieEntity)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.error = error.localizedDescription
                    print("❌ Error updating favorite: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { success in
                if success {
                    print("✅ Favorite status updated successfully in Core Data.")
                    NotificationCenter.default.post(name: NSNotification.Name("FavoriteStatusChanged"), object: nil)
                } else {
                    print("⚠️ Failed to update favorite status.")
                }
            })
            .store(in: &cancellables)
    }
}
