//
//  DetailInteractor.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 29/12/24.
//

import Combine

protocol DetailUseCase {
    func getMovieDetail(by id: Int) -> AnyPublisher<MovieModel, Error>
    func toggleFavoriteStatus(for movie: MovieModel) -> AnyPublisher<Bool, Error>
}

class DetailInteractor: DetailUseCase {
    
    private let repository: MovieRepositoryProtocol
    private let movie: MovieModel
    
    init(repository: MovieRepositoryProtocol, movie: MovieModel) {
        self.repository = repository
        self.movie = movie
    }
    
    func getMovieDetail(by id: Int) -> AnyPublisher<MovieModel, Error> {
        return repository.movieDetail(by: id)
    }
    
    func toggleFavoriteStatus(for movie: MovieModel) -> AnyPublisher<Bool, Error> {
        return repository.toggleFavoriteStatus(for: movie)
    }
}
