//
//  LocaleDataSource.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 26/12/24.
//

import Foundation
import CoreData
import Combine

protocol LocaleDataSourceProtocol: AnyObject {
    func getMovies() -> AnyPublisher<[MoviesEntity], Error>
    func addMovies(from movies: [MoviesEntity]) -> AnyPublisher<Bool, Error>
    func getMovieDetail(by id: Int) -> AnyPublisher<MoviesEntity?, Error>
    
    func saveFavoriteMovie(_ movie: MoviesEntity) throws
    func removeFavoriteMovie(_ movie: MoviesEntity) throws
    func getFavoriteMovies() -> AnyPublisher<[MoviesEntity], Error>
    func isFavorite(movieId: Int) -> Bool
}

final class LocaleDataSource: NSObject {
    
    public let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    static let sharedInstance: (NSPersistentContainer) -> LocaleDataSource = { container in
        return LocaleDataSource(persistentContainer: container)
    }
}

extension LocaleDataSource: LocaleDataSourceProtocol {
    
    func getMovies() -> AnyPublisher<[MoviesEntity], Error> {
        return Future<[MoviesEntity], Error> { completion in
            let context = self.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<MoviesEntity> = MoviesEntity.fetchRequest()
            do {
                let movies = try context.fetch(fetchRequest)
                completion(.success(movies))
            } catch {
                completion(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func addMovies(from movies: [MoviesEntity]) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            let context = self.persistentContainer.viewContext
            do {
                for movie in movies {
                    context.insert(movie)
                }
                try context.save()
                completion(.success(true))
            } catch {
                completion(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func getMovieDetail(by id: Int) -> AnyPublisher<MoviesEntity?, Error> {
        return Future<MoviesEntity?, Error> { completion in
            let context = self.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<MoviesEntity> = MoviesEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            do {
                let movie = try context.fetch(fetchRequest).first
                completion(.success(movie))
            } catch {
                completion(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func saveFavoriteMovie(_ movieEntity: MoviesEntity) throws {
        let context = self.persistentContainer.viewContext
        movieEntity.isFavorite = true
        do {
            context.insert(movieEntity)
            try context.save()
        } catch {
            throw error
        }
    }
    
    func fetchMovieEntity(by id: Int) throws -> MoviesEntity {
        let context = self.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<MoviesEntity> = MoviesEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.fetchLimit = 1

        guard let movie = try context.fetch(fetchRequest).first else {
            throw NSError(domain: "CoreDataError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Movie not found"])
        }
        return movie
    }


    func removeFavoriteMovie(_ movieEntity: MoviesEntity) throws {
        let context = self.persistentContainer.viewContext
        movieEntity.isFavorite = false 
        do {
            context.delete(movieEntity)
            try context.save()
        } catch {
            throw error
        }
    }

    
    func getFavoriteMovies() -> AnyPublisher<[MoviesEntity], Error> {
        let context = self.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<MoviesEntity> = MoviesEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isFavorite == true")

        return Future<[MoviesEntity], Error> { promise in
            context.perform {
                do {
                    let movies = try context.fetch(fetchRequest)
                    promise(.success(movies))
                } catch {
                    print("Error fetching favorite movies: \(error.localizedDescription)")
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }


    func isFavorite(movieId: Int) -> Bool {
        let context = self.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<MoviesEntity> = MoviesEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movieId)
        do {
            if let movie = try context.fetch(fetchRequest).first {
                return movie.isFavorite
            }
        } catch {
            return false
        }
        return false
    }
}
