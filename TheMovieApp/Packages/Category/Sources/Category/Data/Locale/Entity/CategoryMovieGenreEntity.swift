//
//  CategoryMovieGenreEntity.swift
//  Category
//
//  Created by Mochamad Ikhsan Nurdiansyah on 16/03/25.
//

import Foundation
import CoreData

@objc(MovieGenreEntity)
public class CategoryMovieGenreEntity: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryMovieGenreEntity> {
        return NSFetchRequest<CategoryMovieGenreEntity>(entityName: "MovieGenreEntity")
    }
    
    @NSManaged public var id: Int32
    @NSManaged public var name: String?
}
