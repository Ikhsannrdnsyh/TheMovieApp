//
//  SearchInteractor.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 31/12/24.
//

import Combine

protocol SearchUseCase {
    func searchMovies(query: String) -> AnyPublisher<[MovieModel], Error>
}

final class SearchInteractor: SearchUseCase {
    private let repository: MovieRepositoryProtocol
    
    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }
    
    func searchMovies(query: String) -> AnyPublisher<[MovieModel], Error> {
        return repository.searchMovie(query: query)
    }
}
