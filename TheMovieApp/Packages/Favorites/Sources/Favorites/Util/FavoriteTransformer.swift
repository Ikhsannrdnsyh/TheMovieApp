//
//  FavoriteTransformer.swift
//  Favorites
//
//  Created by Mochamad Ikhsan Nurdiansyah on 25/03/25.
//

import Foundation
import Category
import Core
import CoreData

public struct FavoriteTransformer {
    
    public init() {} 
    
    public static func transformResponseToDomain(response: CategoriesResponse) -> [CategoryDomainModel] {
        return response.movies.compactMap { transformMapResponseToDomain($0) }
    }
    
    public static func transformMapResponseToDomain(_ response: CategoryResponse) -> CategoryDomainModel {
        return CategoryDomainModel (
            id: Int32(response.id ?? 0),
            title: response.title ?? "Untitled",
            overview: response.overview ?? "No overview available.",
            posterPath: response.posterPath,
            backdropPath: response.backdropPath,
            category: response.category.flatMap { MovieCategoryType(rawValue: $0) }, 
            releaseDate: DateHelper.parseDate(response.releaseDate),
            runtime: response.runtime ?? 0,
            rating: response.rating ?? 0.0,
            voteCount: response.voteCount ?? 0,
            isFavorite: response.isFavorite ?? false,
            genres: response.genres?.compactMap { MovieGenre(name: $0.name ?? "Unknown") }
        )
    }
    public static func transformDomainToEntity(domain: CategoryDomainModel, context: NSManagedObjectContext) -> MoviesEntity? {
        let fetchRequest: NSFetchRequest<MoviesEntity> = MoviesEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", domain.id)

        do {
            if let existingMovie = try context.fetch(fetchRequest).first {
                existingMovie.isFavorite = domain.isFavorite
                return existingMovie
            }
        } catch {
            print("❌ Error fetching movie entity: \(error.localizedDescription)")
        }
        
        return nil
    }

}
