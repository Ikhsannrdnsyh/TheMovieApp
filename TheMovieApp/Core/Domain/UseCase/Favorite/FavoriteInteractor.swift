//
//  FavoriteInteractor.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 01/01/25.
//

import Combine

protocol FavoriteUseCase {
    func getFavoriteMovies() -> AnyPublisher<[MovieModel], Error>
    func toggleFavoriteStatus(for movie: MovieModel) -> AnyPublisher<Bool, Error>
    func isFavorite(movieId: Int) -> Bool
}

class FavoriteInteractor: FavoriteUseCase {
    private let repository: MovieRepositoryProtocol

    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }

    func getFavoriteMovies() -> AnyPublisher<[MovieModel], Error> {
        return repository.getFavoriteMovies()
    }

    func toggleFavoriteStatus(for movie: MovieModel) -> AnyPublisher<Bool, Error> {
        return repository.toggleFavoriteStatus(for: movie)
    }

    func isFavorite(movieId: Int) -> Bool {
        return repository.isFavorite(movieId: movieId)
    }
}
