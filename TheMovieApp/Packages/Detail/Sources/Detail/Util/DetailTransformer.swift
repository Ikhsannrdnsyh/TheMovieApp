//
//  DetailTransformer.swift
//  Detail
//
//  Created by Mochamad Ikhsan Nurdiansyah on 23/03/25.
//


import Core
import CoreData
import Category

public struct DetailTransformer: Mapper {
    
    
    public typealias Response = [CategoryResponse]
    public typealias Entity = [MoviesEntity]
    public typealias Domain = [CategoryDomainModel]
    
    private let categoryTransformer: CategoryTransformer
    
    public init(context: NSManagedObjectContext) {
        self.categoryTransformer = CategoryTransformer(context: context)
    }
    
    public func transformResponseToEntity(response: [CategoryResponse], category: String) -> [MoviesEntity] {
        return categoryTransformer.transformResponseToEntity(response: response, category: category)
    }
    
    public func transformEntityToDomain(entity: [MoviesEntity]) -> [CategoryDomainModel] {
        return categoryTransformer.transformEntityToDomain(entity: entity)
    }
}
