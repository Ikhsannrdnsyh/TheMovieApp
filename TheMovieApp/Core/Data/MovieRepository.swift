//
//  MovieRepository.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 28/12/24.
//

import Foundation
import Combine
import CoreData

protocol MovieRepositoryProtocol {
    func getFavoriteMovies() -> AnyPublisher<[MovieModel], Error>
    func toggleFavoriteStatus(for movie: MovieModel) -> AnyPublisher<Bool, Error>
    func isFavorite(movieId: Int) -> Bool
    func getNowPlayingMovies() -> AnyPublisher<[MovieModel], Error>
    func getPopularMovies() -> AnyPublisher<[MovieModel], Error>
    func movieDetail(by id: Int) -> AnyPublisher<MovieModel, Error>
    func searchMovie(query: String) -> AnyPublisher<[MovieModel], Error>
}

final class MoviesRepository: NSObject {
    
    typealias MovieInstance = (LocaleDataSource, RemoteDataSource) -> MoviesRepository
    
    fileprivate let remoteDataSource: RemoteDataSource
    fileprivate let localeDataSource: LocaleDataSource
    
    private init(
        remoteDataSource: RemoteDataSource,
        localeDataSource: LocaleDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.localeDataSource = localeDataSource
    }
    
    static let sharedInstance: MovieInstance = { localeRepo, remoteRepo in
        return MoviesRepository(
            remoteDataSource: remoteRepo,
            localeDataSource: localeRepo
        )
    }
}

extension MoviesRepository: MovieRepositoryProtocol {
    func getNowPlayingMovies() -> AnyPublisher<[MovieModel], Error> {
        return self.remoteDataSource.getNowPlayingMovies()
            .map { MoviesMapper.mapResponsesToDomains(response: $0) }
            .eraseToAnyPublisher()
    }
    
    func getPopularMovies() -> AnyPublisher<[MovieModel], Error> {
        return self.remoteDataSource.getPopularMovies()
            .map { MoviesMapper.mapResponsesToDomains(response: $0) }
            .eraseToAnyPublisher()
    }
    
    func movieDetail(by id: Int) -> AnyPublisher<MovieModel, Error> {
        return self.remoteDataSource.getMovieDetail(by: id)
            .map { response in
                var movie = MoviesMapper.mapResponseToDomain(response, isDetail: true)
                movie.isFavorite = self.localeDataSource.isFavorite(movieId: id)
                return movie
            }
            .eraseToAnyPublisher()
    }
    
    func getFavoriteMovies() -> AnyPublisher<[MovieModel], Error> {
        return localeDataSource.getFavoriteMovies()
            .map { moviesEntities in
                return MoviesMapper.mapEntitiesToDomains(entities: moviesEntities)
            }
            .eraseToAnyPublisher()
    }
    
    func toggleFavoriteStatus(for movie: MovieModel) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { [weak self] completion in
            guard let self = self else { return }
            let context = self.localeDataSource.persistentContainer.viewContext

            do {
                // Cek apakah film sudah ada di daftar favorit
                if self.localeDataSource.isFavorite(movieId: Int(movie.id)) {
                    // Hapus dari favorit
                    let movieEntity = try self.localeDataSource.fetchMovieEntity(by: Int(movie.id))
                    try self.localeDataSource.removeFavoriteMovie(movieEntity)
                    try context.save()
                    print("Movie \(movie.id) removed from favorites")
                    completion(.success(false))
                } else {
                    // Simpan ke favorit
                    let movieEntity = MoviesMapper.mapModelToEntity(movie, context: context)
                    try self.localeDataSource.saveFavoriteMovie(movieEntity)
                    try context.save()
                    print("Movie \(movie.id) added to favorites")
                    completion(.success(true))
                }
            } catch {
                print("Error updating favorite status: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func isFavorite(movieId: Int) -> Bool {
        return localeDataSource.isFavorite(movieId: movieId)
    }
    
    func searchMovie(query: String) -> AnyPublisher<[MovieModel], Error> {
        let nowPlayingMovies = self.getNowPlayingMovies()
        let popularMovies = self.getPopularMovies()
        
        return Publishers.CombineLatest(nowPlayingMovies, popularMovies)
            .map { nowPlaying, popular in
                let combinedMovies = Array(Set(nowPlaying + popular))
                guard !query.isEmpty else { return combinedMovies }
                return combinedMovies.filter { $0.title.lowercased().contains(query.lowercased()) }
            }.catch { error -> AnyPublisher<[MovieModel], Error> in
                return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
