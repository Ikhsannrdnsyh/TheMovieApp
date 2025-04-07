//
//  MoviesEntity+CoreDataProperties.swift
//  
//
//  Created by Mochamad Ikhsan Nurdiansyah on 18/03/25.
//
//

import Foundation
import CoreData


extension MoviesEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MoviesEntity> {
        return NSFetchRequest<MoviesEntity>(entityName: "MoviesEntity")
    }

    @NSManaged public var backdropPath: String?
    @NSManaged public var id: Int32
    @NSManaged public var isFavorite: Bool
    @NSManaged public var overview: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var rating: Double
    @NSManaged public var releaseDate: Date?
    @NSManaged public var runtime: Int32
    @NSManaged public var title: String?
    @NSManaged public var voteCount: Int32
    @NSManaged public var genres: NSSet?

}

// MARK: Generated accessors for genres
extension MoviesEntity {

    @objc(addGenresObject:)
    @NSManaged public func addToGenres(_ value: MovieGenreEntity)

    @objc(removeGenresObject:)
    @NSManaged public func removeFromGenres(_ value: MovieGenreEntity)

    @objc(addGenres:)
    @NSManaged public func addToGenres(_ values: NSSet)

    @objc(removeGenres:)
    @NSManaged public func removeFromGenres(_ values: NSSet)

}
