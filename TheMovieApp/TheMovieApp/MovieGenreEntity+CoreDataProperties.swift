//
//  MovieGenreEntity+CoreDataProperties.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 01/01/25.
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
    @NSManaged public var genres: MoviesEntity?

}

extension MovieGenreEntity : Identifiable {

}
