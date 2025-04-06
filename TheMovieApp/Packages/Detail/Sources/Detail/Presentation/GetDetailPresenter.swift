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
                    print("❌ Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { movie in
                self.movie = movie
                if let movie = movie as? CategoryDomainModel {
                    self.isFavorite = movie.isFavorite
                }
                print("✅ Detail Movie: \(String(describing: movie))")
            })
            .store(in: &cancellables)
    }
    
    @MainActor
    public func toggleFavoriteStatus() {
        guard var movie = movie as? CategoryDomainModel else {
            print("❌ Error: Movie data is nil atau bukan CategoryDomainModel")
            return
        }

        let newStatus = !movie.isFavorite
        print("🔄 Before toggle: \(movie.isFavorite) -> After toggle: \(newStatus)")

        movie.isFavorite = newStatus
        self.isFavorite = newStatus
        self.movie = movie as? Response

        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        // Coba fetch entity dari database
        var movieEntity = FavoriteTransformer.transformDomainToEntity(domain: movie, context: context)
        
        // Jika entity tidak ditemukan, buat entitas baru
        if movieEntity == nil {
            movieEntity = MoviesEntity(context: context)
            movieEntity?.id = movie.id
            movieEntity?.title = movie.title
            movieEntity?.overview = movie.overview
            movieEntity?.posterPath = movie.posterPath
            movieEntity?.backdropPath = movie.backdropPath
            movieEntity?.categoryEnum = movie.category
            movieEntity?.releaseDate = movie.releaseDate
            movieEntity?.runtime = movie.runtime ?? 0
            movieEntity?.rating = movie.rating
            movieEntity?.voteCount = movie.voteCount
            movieEntity?.isFavorite = movie.isFavorite
        } else {
            movieEntity?.isFavorite = movie.isFavorite
        }
        
        // Simpan ke Core Data
        do {
            try context.save()
            print("✅ Core Data sukses menyimpan perubahan favorit.")
            NotificationCenter.default.post(name: NSNotification.Name("FavoriteStatusChanged"), object: nil)
        } catch {
            print("❌ Error menyimpan favorit ke Core Data: \(error.localizedDescription)")
            self.error = error.localizedDescription
        }
    }
}
