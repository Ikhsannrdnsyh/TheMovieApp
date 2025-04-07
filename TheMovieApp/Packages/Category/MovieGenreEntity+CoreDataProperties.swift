//
//  MovieGenreEntity+CoreDataProperties.swift
//  
//
//  Created by Mochamad Ikhsan Nurdiansyah on 07/04/25.
//
//

import Foundation
import CoreData
import Category

extension MovieGenreEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieGenreEntity> {
        return NSFetchRequest<MovieGenreEntity>(entityName: "MovieGenreEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: Int32
    @NSManaged public var movie: MoviesEntity?

}
