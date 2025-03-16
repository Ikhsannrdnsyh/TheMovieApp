//
//  GetCategoriesLocaleDataSource.swift
//  Category
//
//  Created by Mochamad Ikhsan Nurdiansyah on 16/03/25.
//

import Core
import Combine
import CoreData
import Foundation

@MainActor
public struct GetCategoriesLocaleDataSource: @preconcurrency LocaleDataSource {
    
    public typealias Request = MovieCategoryType
    public typealias Response = CategoryModuleEntity
    
    private let context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }
    
    // MARK: - Ambil Semua Film dari CoreData
    public func getMovies(request: Request) -> AnyPublisher<[CategoryModuleEntity], Error> {
        return Future { completion in
            self.context.perform {
                let fetchRequest: NSFetchRequest<CategoryModuleEntity> = CategoryModuleEntity.fetchRequest()
                do {
                    let movies = try self.context.fetch(fetchRequest)
                    completion(.success(movies))
                } catch {
                    completion(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    // MARK: - Tambah Film ke CoreData
    public func addMovies(entities: [CategoryModuleEntity]) -> AnyPublisher<Bool, Error> {
        return Future { completion in
            self.context.perform {
                do {
                    for movie in entities {
                        // Cek apakah film sudah ada berdasarkan id
                        let fetchRequest: NSFetchRequest<CategoryModuleEntity> = CategoryModuleEntity.fetchRequest()
                        fetchRequest.predicate = NSPredicate(format: "id == %d", movie.id)
                        
                        let existingMovies = try self.context.fetch(fetchRequest)
                        if existingMovies.isEmpty {
                            self.context.insert(movie)
                        }
                    }
                    
                    // Simpan hanya sekali setelah loop selesai
                    if self.context.hasChanges {
                        try self.context.save()
                    }
                    
                    completion(.success(true))
                } catch {
                    completion(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    // MARK: - Ambil Detail Film berdasarkan ID
    public func getMovieDetail(id: Int) -> AnyPublisher<CategoryModuleEntity, Error> {
        return Future { promise in
            self.context.perform {
                let fetchRequest: NSFetchRequest<CategoryModuleEntity> = CategoryModuleEntity.fetchRequest()
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
}
