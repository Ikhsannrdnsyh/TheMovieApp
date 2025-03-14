//
//  HomeInteractor.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 29/12/24.
//

import Foundation
import Combine

protocol HomeUseCase {
    func getNowPlayingMovies() -> AnyPublisher<[MovieModel], Error>
    func getPopularMovies() -> AnyPublisher<[MovieModel], Error>
}

class HomeInteractor: HomeUseCase {
    private let repository: MovieRepositoryProtocol

    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }

    func getNowPlayingMovies() -> AnyPublisher<[MovieModel], Error> {
        return repository.getNowPlayingMovies()
    }

    func getPopularMovies() -> AnyPublisher<[MovieModel], Error> {
        return repository.getPopularMovies()
    }
}
