//
//  DetailPresenter.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 29/12/24.
//

import Combine
import Foundation

class DetailPresenter: ObservableObject {
    private let movieDetailUseCase: DetailUseCase
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var movie: MovieModel? = nil
    @Published var isLoading: Bool = false
    @Published var error: String? = nil
    @Published var isFavorite: Bool = false
    
    private var movieId: Int?
    
    init(movieId: Int, movieDetailUseCase: DetailUseCase) {
        self.movieId = movieId
        self.movieDetailUseCase = movieDetailUseCase
    }
    
    func getMovieDetail() {
        guard let movieId = movieId else { return }
        
        isLoading = true
        error = nil
        
        movieDetailUseCase.getMovieDetail(by: movieId)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.error = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { movie in
                self.movie = movie
                self.isFavorite = movie.isFavorite
            })
            .store(in: &cancellables)
    }
    
    func toggleFavoriteStatus() {
        guard let movie = movie else { return }
        let newStatus = !movie.isFavorite
        print("Before toggle \(movie.isFavorite) -> After toggle: \(newStatus)")
        movieDetailUseCase.toggleFavoriteStatus(for: movie)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.error = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { success in
                
                if success {
                    self.isFavorite = newStatus
                    self.movie?.isFavorite = newStatus
                    print("Favorite status updated: \(self.isFavorite)")
                } else {
                    self.isFavorite = newStatus
                    self.movie?.isFavorite = newStatus
                }
                self.getMovieDetail()
            })
            .store(in: &cancellables)
    }
}
