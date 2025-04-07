//
//  MoviesEntity.swift
//  Category
//
//  Created by Mochamad Ikhsan Nurdiansyah on 16/03/25.
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
    @NSManaged public var category: String?
    @NSManaged public var releaseDate: Date?
    @NSManaged public var rating: Double
    @NSManaged public var runtime: Int32
    @NSManaged public var voteCount: Int32
    @NSManaged public var isFavorite: Bool
    @NSManaged public var genreIds: [Int]?
    @NSManaged public var genres: Set<MovieGenreEntity>

    public var genresArray: [MovieGenreEntity] {
        return Array(genres)
    }
    
    @objc public var genreNames: [String] {
        return genresArray.map { $0.name ?? "" }
    }
    
    
    public var categoryEnum: MovieCategoryType? {
        get {
            guard let category = category else { return nil }
            return MovieCategoryType(rawValue: category)
        }
        set {
            category = newValue?.rawValue
        }
    }

}
