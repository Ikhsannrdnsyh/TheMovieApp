//
//  GetFavoritesRepository.swift
//  Favorites
//
//  Created by Mochamad Ikhsan Nurdiansyah on 25/03/25.
//

import Combine
import Core
import Category
import Foundation
import CoreData

public struct GetFavoritesRepository<
    FavoriteLocal: FavoriteLocalDataSource,
    FavoriteRemote: DataSource
>: Repository where
FavoriteLocal.Request == Int,
FavoriteLocal.Response == MoviesEntity,
FavoriteRemote.Request == Int,
FavoriteRemote.Response == [CategoryResponse] {
    
    public typealias Request = Int
    public typealias Response = [CategoryDomainModel]
    
    private let localDataSource: FavoriteLocal
    private let remoteDataSource: FavoriteRemote
    private let transformer: FavoriteTransformer
    
    public init(
        localDataSource: FavoriteLocal,
        remoteDataSource: FavoriteRemote,
        transformer: FavoriteTransformer
    ) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
        self.transformer = transformer
    }
    
    public func execute(request: Int? = nil) -> AnyPublisher<[CategoryDomainModel], Error> {
        print("🟢 Debug: Request Masuk - \(String(describing: request))") // Debugging
        
        return localDataSource.getFavoriteMovies()
            .flatMap { localMovies -> AnyPublisher<[CategoryDomainModel], Error> in
                if !localMovies.isEmpty {
                    print("📌 Debug: Mengambil data dari lokal database")
                    return Just(localMovies.map { movie in
                        CategoryDomainModel(
                            id: movie.id,
                            title: movie.title ?? "Untitled",
                            overview: movie.overview ?? "No overview available.",
                            posterPath: movie.posterPath,
                            backdropPath: movie.backdropPath,
                            category: movie.category.flatMap { MovieCategoryType(rawValue: $0) },
                            releaseDate: movie.releaseDate,
                            runtime: Int32(movie.runtime),
                            rating: movie.rating,
                            voteCount: Int32(movie.voteCount),
                            isFavorite: movie.isFavorite,
                            genres: movie.genres.compactMap { MovieGenre(name: $0.name ?? "Unknown") },
                            genreIds: movie.genreIds ?? []
                        )
                    })
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
                } else {
                    print("🌐 Debug: Data lokal kosong, tidak mengambil dari remote API")
                    return Just([]) 
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
            }
            .catch { error in
                print("❌ Error: Gagal mengambil data favorit - \(error.localizedDescription)")
                return Just<[CategoryDomainModel]>([])
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    
    @MainActor
    public func updateFavoriteStatus(for movie: MoviesEntity) -> AnyPublisher<Bool, Error> {
        return Future { promise in
            let context = CoreDataManager.shared.context
            let fetchRequest: NSFetchRequest<MoviesEntity> = MoviesEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", movie.id)

            do {
                if let entity = try context.fetch(fetchRequest).first {
                    entity.isFavorite.toggle()
                    print(entity.isFavorite ? "✅ Movie marked as favorite." : "❌ Movie removed from favorites.")

                    try context.save()
                    promise(.success(true))
                    
                    NotificationCenter.default.post(name: NSNotification.Name("FavoriteStatusChanged"), object: nil)
                    
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
