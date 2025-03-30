//
//  GetFavoriteLocaleDataSource.swift
//  Favorites
//
//  Created by Mochamad Ikhsan Nurdiansyah on 25/03/25.
//

import Core
import Category
import CoreData
import Combine

@MainActor
public struct GetFavoriteLocaleDataSource: @preconcurrency FavoriteLocalDataSource{
    
    
    public typealias Request = Int
    public typealias Response = MoviesEntity
    
    private let context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }
    
    public func getFavoriteMovies() -> AnyPublisher<[MoviesEntity], any Error> {
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
    
    public func updateFavoriteStatus(for movie: MoviesEntity) -> AnyPublisher<Bool, any Error> {
        return Future { promise in
            let context = self.context
            
            let fetchRequest: NSFetchRequest<MoviesEntity> = MoviesEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", movie.id)
            
            do {
                if let entity = try context.fetch(fetchRequest).first {
                    entity.isFavorite.toggle() 
                    
                    try context.save()
                    promise(.success(true))
                } else {
                    promise(.failure(NSError(domain: "CoreData", code: 404, userInfo: [NSLocalizedDescriptionKey: "Movie not found"])))
                }
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
