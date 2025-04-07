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
        response.forEach {
            print("📥 Incoming Response ID: \($0.id ?? 0), genres: \($0.genres?.map { $0.name ?? "-" } ?? []), genreIds: \($0.genreIds ?? [])")
        }
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
            
            if let ids = categoryResponse.genreIds {
                entity.genreIds = ids.map { Int($0) }
            } else if let genres = categoryResponse.genres {
                let ids = genres.compactMap { $0.id }
                entity.genreIds = ids
            }
            
            let mutableGenres = entity.mutableSetValue(forKey: "genres")
            
            if let genres = categoryResponse.genres, !genres.isEmpty {
                for genre in genres {
                    guard let genreId = genre.id else { continue }
                    let genreEntity = MovieGenreEntity(context: context)
                    genreEntity.id = Int32(genreId)
                    genreEntity.name = genre.name ?? GenreHelper.genreName(for: genreId)
                    mutableGenres.add(genreEntity)
                }
            } else if let genreIDs = categoryResponse.genreIds {
                for genreID in genreIDs {
                    let genreEntity = MovieGenreEntity(context: context)
                    genreEntity.id = Int32(genreID)
                    genreEntity.name = GenreHelper.genreName(for: genreID)
                    mutableGenres.add(genreEntity)
                }
            }
            
            return entity
        }
    }
    
    public func transformEntityToDomain(entity: [MoviesEntity]) -> [CategoryDomainModel] {
        return entity.map { category in
            CategoryDomainModel(
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
                genres: Array(category.genres).compactMap {
                    ($0 as? MovieGenreEntity).flatMap { MovieGenre(name: $0.name ?? "Unknown") }
                },
                genreIds: (category.genreIds as? [Int]) ?? (category.genreIds as? [NSNumber])?.map { $0.intValue }
            )
        }
    }
}
