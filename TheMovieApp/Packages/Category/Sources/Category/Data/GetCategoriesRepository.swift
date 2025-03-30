//
//  GetCategoriesRepository.swift
//  Category
//
//  Created by Mochamad Ikhsan Nurdiansyah on 16/03/25.
//

import Combine
import Core
import Foundation
import CoreData

public struct GetCategoriesRepository<
    CategoryLocaleDataSource: LocaleDataSource,
    RemoteDataSource: DataSource,
    Transformer: Mapper
>: Repository where
CategoryLocaleDataSource.Request == MovieCategoryType,
CategoryLocaleDataSource.Response == MoviesEntity,
RemoteDataSource.Request == MovieCategoryType,
RemoteDataSource.Response == [CategoryResponse],
Transformer.Response == [CategoryResponse],
Transformer.Entity == [MoviesEntity],
Transformer.Domain == [CategoryDomainModel] {
    
    public typealias Request = MovieCategoryType
    public typealias Response = [CategoryDomainModel]
    
    private let localeDataSource: CategoryLocaleDataSource
    private let remoteDataSource: RemoteDataSource
    private let mapper: Transformer
    
    public init(
        localeDataSource: CategoryLocaleDataSource,
        remoteDataSource: RemoteDataSource,
        mapper: Transformer
    ) {
        self.localeDataSource = localeDataSource
        self.remoteDataSource = remoteDataSource
        self.mapper = mapper
    }
    
    public func execute(request: MovieCategoryType?) -> AnyPublisher<[CategoryDomainModel], Error> {
        print("Debug: Request Masuk - \(String(describing: request))") // Debugging
        
        guard let categoryType = request else {
            print("Error: Request tidak valid (nil)")
            return Fail(error: NSError(domain: "InvalidRequest", code: 400, userInfo: [NSLocalizedDescriptionKey: "Request tidak valid"]))
                .eraseToAnyPublisher()
        }
        
        print("Debug: Request Diterima - \(categoryType.rawValue)")
        
        return localeDataSource.getMovies(request: categoryType)
            .flatMap { localMovies -> AnyPublisher<[CategoryDomainModel], Error> in
                if !localMovies.isEmpty {
                    return Just(localMovies)
                        .setFailureType(to: Error.self)
                        .map { mapper.transformEntityToDomain(entity: $0) }
                        .eraseToAnyPublisher()
                } else {
                    return remoteDataSource.execute(request: categoryType)
                        .flatMap { response -> AnyPublisher<[CategoryDomainModel], Error> in
                            let categoryString = categoryType.rawValue.lowercased()
                            let entities = mapper.transformResponseToEntity(response: response, category: categoryString)
                            
                            return localeDataSource.addMovies(entities: entities)
                                .filter { $0 }
                                .flatMap { _ in localeDataSource.getMovies(request: categoryType) }
                                .map { mapper.transformEntityToDomain(entity: $0) }
                                .eraseToAnyPublisher()
                        }
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    @MainActor
    public func toggleFavoriteStatus(for movie: CategoryDomainModel) -> AnyPublisher<Bool, Error> {
            return Future { promise in
                let context = CoreDataManager.shared.context

                let fetchRequest: NSFetchRequest<MoviesEntity> = MoviesEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %d", movie.id)

                do {
                    if let movieEntity = try context.fetch(fetchRequest).first {
                        movieEntity.isFavorite = movie.isFavorite
                        try context.save()
                        promise(.success(true))
                    } else {
                        promise(.success(false))
                    }
                } catch {
                    promise(.failure(error))
                }
            }
            .eraseToAnyPublisher()
        }
}
