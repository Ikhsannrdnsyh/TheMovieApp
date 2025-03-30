//
//  GetSearchLocaleDataSource.swift
//  Search
//
//  Created by Mochamad Ikhsan Nurdiansyah on 26/03/25.
//
//
//  GetSearchLocaleDataSource.swift
//  Search
//
//  Created by Mochamad Ikhsan Nurdiansyah on 26/03/25.
//
import Core
import CoreData
import Category
import Combine

@MainActor
public struct GetSearchLocaleDataSource: @preconcurrency SearchLocaleDataSource {
    
    public typealias Request = String
    public typealias Response = [MoviesEntity]

    private let context: NSManagedObjectContext

    public init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }

    public func searchMovie(query: String) -> AnyPublisher<[MoviesEntity], Error> {
        return Future<[MoviesEntity], Error> { promise in
            context.perform {
                do {
                    let fetchRequest: NSFetchRequest<MoviesEntity> = MoviesEntity.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "title CONTAINS[cd] %@", query)
                    fetchRequest.returnsObjectsAsFaults = false 
                    let movies = try context.fetch(fetchRequest)

                    
                    print("🔍 Local Search Result: \(movies)") // Debugging
                    
                    promise(.success(movies))
                } catch {
                    print("❌ Error fetching search results: \(error.localizedDescription)")
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
