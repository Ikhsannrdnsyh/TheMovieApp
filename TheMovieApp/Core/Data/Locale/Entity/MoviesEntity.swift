//
//  MoviesEntity.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 24/12/24.
//

import Foundation
import CoreData

@objc(MoviesEntity)
public class MoviesEntity: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MoviesEntity> {
        return NSFetchRequest<MoviesEntity>(entityName: "MoviesEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String
    @NSManaged public var overview: String
    @NSManaged public var posterPath: String?
    @NSManaged public var backdropPath: String?
    @NSManaged public var releaseDate: Date?
    @NSManaged public var rating: Double
    @NSManaged public var runtime: Int32
    @NSManaged public var voteCount: Int32
    @NSManaged public var isFavorite: Bool
    @NSManaged public var genres: Set<MovieGenreEntity>

    public var genresArray: [MovieGenreEntity] {
        return Array(genres)
    }
    
    @objc public var genreNames: [String] {
        return genresArray.map { $0.name ?? "" }
    }
}
