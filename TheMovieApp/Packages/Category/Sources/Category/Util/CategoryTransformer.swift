//
//  CategoryTransformer.swift
//  Category
//
//  Created by Mochamad Ikhsan Nurdiansyah on 16/03/25.
//

import Core
import CoreData

public struct CategoryTransformer: Mapper {
    
    public typealias Response = [CategoryResponse]
    public typealias Entity = [MoviesEntity]
    public typealias Domain = [CategoryDomainModel]
    
    private let context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func transformResponseToEntity(response: [CategoryResponse], category: String) -> [MoviesEntity] {
        return response.map { categoryResponse in
            let entity = MoviesEntity(context: context)
            entity.id = Int32(categoryResponse.id ?? 0)
            entity.title = categoryResponse.title ?? "Untitled"
            entity.overview = categoryResponse.overview ?? "No Overview"
            entity.posterPath = ImageUrlHelper.buildPosterUrl(from: categoryResponse.posterPath)
            entity.category = category.lowercased()
            entity.backdropPath = ImageUrlHelper.buildBackdropUrl(from: categoryResponse.backdropPath)
            entity.releaseDate = DateHelper.parseDate(categoryResponse.releaseDate)
            entity.runtime = Int32(categoryResponse.runtime ?? 0)
            entity.rating = categoryResponse.rating ?? 0.0
            entity.voteCount = Int32(categoryResponse.voteCount ?? 0)
            entity.isFavorite = false
            
            let mutableGenres = entity.mutableSetValue(forKey: "genres")
            
            if let genres = categoryResponse.genres {
                for genre in genres {
                    guard let genreId = genre.id else { continue }
                    let genreEntity = MovieGenreEntity(context: context)
                    genreEntity.id = Int32(genreId)
                    genreEntity.name = genre.name ?? "Unknown Genre"
                    mutableGenres.add(genreEntity)
                }
            }
            return entity
        }
    }
    
    public func transformEntityToDomain(entity: [MoviesEntity]) -> [CategoryDomainModel] {
        return entity.map { category in
            return CategoryDomainModel(
                id: category.id,
                title: category.title,
                overview: category.overview,
                posterPath: ImageUrlHelper.buildPosterUrl(from: category.posterPath),
                backdropPath: ImageUrlHelper.buildBackdropUrl(from: category.backdropPath),
                category: category.category.flatMap { MovieCategoryType(rawValue: $0) },
                releaseDate: category.releaseDate,
                runtime: category.runtime,
                rating: category.rating,
                voteCount: category.voteCount,
                isFavorite: category.isFavorite,
                genres: Array(category.genres).compactMap { MovieGenre(name: $0.name ?? "Unknown") }
            )
        }
    }
    
}
