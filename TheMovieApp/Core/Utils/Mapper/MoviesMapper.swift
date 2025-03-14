//
//  MoviesMapper.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 28/12/24.
//

import Foundation
import CoreData

struct MoviesMapper {
    
    static func mapResponsesToDomains(response: MoviesResponse) -> [MovieModel] {
        return response.movies.compactMap { mapResponseToDomain($0) }
    }
    
    static func mapResponseToDomain(_ response: MovieResponse, isDetail: Bool = false) -> MovieModel {
        return MovieModel(
            id: Int32(response.id ?? 0),
            title: response.title ?? "Untitled",
            overview: response.overview ?? "No overview available.",
            posterPath: ImageUrlHelper.buildPosterUrl(from: response.posterPath),
            backdropPath: ImageUrlHelper.buildBackdropUrl(from: response.backdropPath),
            releaseDate: DateHelper.parseDate(response.releaseDate),
            runtime: isDetail ? (response.runtime ?? 0) : 0,
            rating: response.rating ?? 0.0,
            voteCount: response.voteCount ?? 0,
            isFavorite: response.isFavorite ?? false,
            genres: response.genres?.compactMap { MovieGenre(name: $0.name ?? "Unknown") }
        )
    }
    
    static func mapResponsesToEntities(response: MoviesResponse, context: NSManagedObjectContext) -> [MoviesEntity] {
        return response.movies.compactMap { mapResponseToEntity($0, context: context) }
    }
    
    static func mapResponseToEntity(_ response: MovieResponse, context: NSManagedObjectContext) -> MoviesEntity {
        let movieEntity = MoviesEntity(context: context)
        movieEntity.id = Int32(response.id ?? 0)
        movieEntity.title = response.title ?? "Untitled"
        movieEntity.overview = response.overview ?? "No overview available."
        movieEntity.posterPath = response.posterPath
        movieEntity.backdropPath = response.backdropPath
        movieEntity.runtime = Int32(response.runtime ?? 0)
        movieEntity.releaseDate = DateHelper.parseDate(response.releaseDate)
        movieEntity.rating = response.rating ?? 0.0
        movieEntity.voteCount = Int32(response.voteCount ?? 0)
        movieEntity.isFavorite = response.isFavorite ?? false
        
        let genreEntities = response.genres?.compactMap { genre -> MovieGenreEntity? in
            let genreEntity = MovieGenreEntity(context: context)
            genreEntity.name = genre.name ?? "Unknown"
            return genreEntity
        } ?? []
        
        for genreEntity in genreEntities {
            movieEntity.mutableSetValue(forKey: "genres").add(genreEntity)
        }
        
        return movieEntity
    }
    static func mapEntitiesToDomains(entities: [MoviesEntity]) -> [MovieModel] {
        return entities.compactMap { mapEntityToDomain($0) }
    }
    
    static func mapEntityToDomain(_ entity: MoviesEntity) -> MovieModel {
        return MovieModel(
            id: Int32(entity.id),
            title: entity.title,
            overview: entity.overview,
            posterPath: ImageUrlHelper.buildPosterUrl(from: entity.posterPath),
            backdropPath: ImageUrlHelper.buildBackdropUrl(from: entity.backdropPath),
            releaseDate: entity.releaseDate,
            runtime: entity.runtime,
            rating: entity.rating,
            voteCount: entity.voteCount,
            isFavorite: entity.isFavorite,
            genres: Array(entity.genres).compactMap { MovieGenre(name: $0.name ?? "Unknown") }
        )
    }
    
    static func mapModelToEntity(_ model: MovieModel, context: NSManagedObjectContext) -> MoviesEntity {
        let movieEntity = MoviesEntity(context: context)
        movieEntity.id = model.id
        movieEntity.title = model.title
        movieEntity.overview = model.overview
        movieEntity.posterPath = model.posterPath
        movieEntity.backdropPath = model.backdropPath
        movieEntity.releaseDate = model.releaseDate
        movieEntity.runtime = model.runtime ?? 0
        movieEntity.rating = model.rating
        movieEntity.voteCount = model.voteCount
        movieEntity.isFavorite = model.isFavorite
        return movieEntity
    }
}
