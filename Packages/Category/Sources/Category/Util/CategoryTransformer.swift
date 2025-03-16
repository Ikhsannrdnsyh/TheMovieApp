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
    public typealias Entity = [CategoryModuleEntity]
    public typealias Domain = [CategoryDomainModel]
    
    private let context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func transformResponseToEntity(response: [CategoryResponse]) -> [CategoryModuleEntity] {
        return response.map { category in
            let entity = CategoryModuleEntity(context: context)
            entity.id = Int32(category.id ?? 0)
            entity.title = category.title ?? "Untitled"
            entity.overview = category.overview ?? "No Overview"
            entity.posterPath = category.posterPath
            entity.backdropPath = category.backdropPath
            entity.releaseDate = DateHelper.parseDate(category.releaseDate)
            entity.runtime = Int32(category.runtime ?? 0)
            entity.rating = category.rating ?? 0.0
            entity.voteCount = Int32(category.voteCount ?? 0)
            entity.isFavorite = false
            
            let mutableGenres = entity.mutableSetValue(forKey: "genres")
            for genreResponse in category.genres ?? [] {
                let genreEntity = CategoryMovieGenreEntity(context: context)
                genreEntity.name = genreResponse.name ?? "Unknown Genre"
                mutableGenres.add(genreEntity)
            }
            
            return entity
        }
    }
    
    public func transformEntityToDomain(entity: [CategoryModuleEntity]) -> [CategoryDomainModel] {
        return entity.map { category in
            return CategoryDomainModel(
                id: category.id,
                title: category.title,
                overview: category.overview,
                posterPath: category.posterPath,
                backdropPath: category.backdropPath,
                releaseDate: category.releaseDate,
                runtime: category.runtime,
                rating: category.rating,
                voteCount: category.voteCount,
                isFavorite: category.isFavorite,
                genres: category.genresArray.map { MovieGenre(name: $0.name ?? "Unknown Genre") }
            )
        }
    }
}
