//
//  MovieGenreEntity.swift
//  Category
//
//  Created by Mochamad Ikhsan Nurdiansyah on 16/03/25.
//

import Foundation
import CoreData

@objc(MovieGenreEntity)
public class MovieGenreEntity: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieGenreEntity> {
        return NSFetchRequest<MovieGenreEntity>(entityName: "MovieGenreEntity")
    }
    
    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var movie: MoviesEntity?
}

extension MovieGenreEntity : Identifiable {

}
