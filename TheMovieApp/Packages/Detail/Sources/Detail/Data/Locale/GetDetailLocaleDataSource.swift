//
//  GetDetailLocaleDataSource.swift
//  Detail
//
//  Created by Mochamad Ikhsan Nurdiansyah on 23/03/25.
//
import Combine
import Core
import CoreData
import Category

@MainActor
public struct GetDetailLocaleDataSource: @preconcurrency DetailLocaleDataSource{
    
    public typealias Request = Int
    public typealias Response = MoviesEntity
    
    private let context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }
    
    public func getMovieDetail(id: Int) -> AnyPublisher<MoviesEntity, any Error> {
        return Future { promise in
            self.context.perform {
                let fetchRequest: NSFetchRequest<MoviesEntity> = MoviesEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %d", id)
                
                do {
                    if let movie = try self.context.fetch(fetchRequest).first {
                        promise(.success(movie))
                    } else {
                        promise(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Movie not found"])))
                    }
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func saveFavoriteMovie(_ movie: MoviesEntity) throws {
        movie.isFavorite = true
        do {
            context.insert(movie)
            try context.save()
        } catch {
            throw error
        }
    }
    
    public func removeFavoriteMovie(_ movie: MoviesEntity) throws {
        movie.isFavorite = false
        do {
            context.delete(movie)
            try context.save()
        } catch {
            throw error
        }
    }
    
    public func isFavorite(movieId: Int) -> Bool {
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
    
    public func addMovieDetail(entity: MoviesEntity) throws {
            context.insert(entity)
            try context.save()
        }
}
