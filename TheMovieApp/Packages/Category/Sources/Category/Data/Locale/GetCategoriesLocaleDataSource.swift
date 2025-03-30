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
    public typealias Response = MoviesEntity
    
    private let context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }
    
    // MARK: - Ambil Semua Film dari CoreData
    public func getMovies(request: Request) -> AnyPublisher<[MoviesEntity], Error> {
        print("🔍 Fetching movies for category: \(request.rawValue)...")
        return Future { completion in
            self.context.perform {
                let fetchRequest: NSFetchRequest<MoviesEntity> = MoviesEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "category == %@", request.rawValue.lowercased()) // 🔥 Pastikan lowercase
                
                do {
                    let movies = try self.context.fetch(fetchRequest)
                    print("✅ Found \(movies.count) movies in Core Data for category: \(request.rawValue)")
                    
                    for movie in movies {
                        print("🎬 Movie: \(movie.title) (ID: \(movie.id)) - Category: \(movie.category ?? "Unknown")")
                    }
                    
                    DispatchQueue.main.async {
                        completion(.success(movies))
                    }
                } catch {
                    print("❌ Error fetching movies: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
    
    
    
    // MARK: - Tambah Film ke CoreData
    public func addMovies(entities: [MoviesEntity]) -> AnyPublisher<Bool, Error> {
        print("📀 Saving \(entities.count) movies to Core Data...")
        
        return Future { completion in
            self.context.perform {
                do {
                    var isChanged = false
                    let movieIDs = entities.map { $0.id }
                    
                    // Fetch all existing movies in one request
                    let fetchRequest: NSFetchRequest<MoviesEntity> = MoviesEntity.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "id IN %@", movieIDs)
                    let existingMovies = try self.context.fetch(fetchRequest)
                    
                    // Convert to dictionary for quick lookup
                    var movieDict = existingMovies.reduce(into: [Int32: MoviesEntity]()) { dict, movie in
                        dict[movie.id] = movie // Jika ada duplikasi, hanya yang terakhir disimpan
                    }

                    for movie in entities {
                        if let existingMovie = movieDict[movie.id] {
                            // Update category jika belum ada
                            if let existingCategory = existingMovie.category,
                               let newCategory = movie.category?.lowercased(),
                               !existingCategory.contains(newCategory) {
                                
                                existingMovie.category = (existingCategory + ", " + newCategory)
                                print("🔄 Updated category for movie: \(existingMovie.title) (ID: \(existingMovie.id)) - New category: \(existingMovie.category ?? "Unknown")")
                                isChanged = true
                            } else {
                                print("⚠️ Movie already exists: \(movie.title) (ID: \(movie.id)) - Existing category: \(existingMovie.category ?? "Unknown")")
                            }
                        } else {
                            // Insert new movie
                            let newMovie = MoviesEntity(context: self.context)
                            newMovie.id = movie.id
                            newMovie.title = movie.title
                            newMovie.overview = movie.overview
                            newMovie.posterPath = movie.posterPath
                            newMovie.category = movie.category?.lowercased()
                            newMovie.backdropPath = movie.backdropPath
                            newMovie.releaseDate = movie.releaseDate
                            newMovie.runtime = movie.runtime
                            newMovie.rating = movie.rating
                            newMovie.voteCount = movie.voteCount
                            newMovie.isFavorite = false
                            newMovie.genres = movie.genres
                            
                            print("✅ Inserted movie: \(newMovie.title) (ID: \(newMovie.id)) - Category: \(newMovie.category ?? "Unknown")")
                            isChanged = true
                        }
                    }
                    
                    if isChanged {
                        try self.context.save()
                        print("✅ Core Data save successful!")
                    } else {
                        print("⚠️ No new movies to save.")
                    }
                    
                    DispatchQueue.main.async {
                        completion(.success(isChanged))
                    }
                } catch {
                    print("❌ Error saving movies: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
    
}

