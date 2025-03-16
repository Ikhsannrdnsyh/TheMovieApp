//
//  CategoryModuleEntity.swift
//  Category
//
//  Created by Mochamad Ikhsan Nurdiansyah on 16/03/25.
//
import Foundation
import CoreData

@objc(CategoryModuleEntity)
public class CategoryModuleEntity: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryModuleEntity> {
        return NSFetchRequest<CategoryModuleEntity>(entityName: "MoviesEntity")
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
    @NSManaged public var genres: Set<CategoryMovieGenreEntity>

    public var genresArray: [CategoryMovieGenreEntity] {
        return Array(genres)
    }
    
    @objc public var genreNames: [String] {
        return genresArray.map { $0.name ?? "" }
    }
}
