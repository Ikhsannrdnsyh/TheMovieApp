//
//  GetCategoriesRepository.swift
//  Category
//
//  Created by Mochamad Ikhsan Nurdiansyah on 16/03/25.
//

import Combine
import Core
import Foundation

public struct GetCategoriesRepository<
    CategoryLocaleDataSource: LocaleDataSource,
    RemoteDataSource: DataSource,
    Transformer: Mapper
>: Repository where
CategoryLocaleDataSource.Request == MovieCategoryType,
CategoryLocaleDataSource.Response == CategoryModuleEntity,
RemoteDataSource.Request == MovieCategoryType,
RemoteDataSource.Response == [CategoryResponse],
Transformer.Response == [CategoryResponse],
Transformer.Entity == [CategoryModuleEntity],
Transformer.Domain == [CategoryDomainModel] 
{
    
    public typealias Request = MovieCategoryType
    public typealias Response = [CategoryDomainModel]
    
    private let _localeDataSource: CategoryLocaleDataSource
    private let _remoteDataSource: RemoteDataSource
    private let _mapper: Transformer
    
    public init(
        localeDataSource: CategoryLocaleDataSource,
        remoteDataSource: RemoteDataSource,
        mapper: Transformer) {
            
            _localeDataSource = localeDataSource
            _remoteDataSource = remoteDataSource
            _mapper = mapper
        }
    
    public func execute(request: MovieCategoryType?) -> AnyPublisher<[CategoryDomainModel], Error> {
        guard let categoryType = request else {
            return Fail(error: NSError(domain: "InvalidRequest", code: 400, userInfo: nil))
                .eraseToAnyPublisher()
        }
        
        return _localeDataSource.getMovies(request: categoryType)
            .flatMap { result -> AnyPublisher<[CategoryDomainModel], Error> in
                if result.isEmpty {
                    return _remoteDataSource.execute(request: categoryType)
                        .map { _mapper.transformResponseToEntity(response: $0) }
                        .catch { _ in _localeDataSource.getMovies(request: categoryType) }
                        .flatMap { _localeDataSource.addMovies(entities: $0) }
                        .filter { $0 }
                        .flatMap { _ in _localeDataSource.getMovies(request: categoryType)
                                .map { _mapper.transformEntityToDomain(entity: $0) }
                        }
                        .eraseToAnyPublisher()
                } else {
                    return _localeDataSource.getMovies(request: categoryType)
                        .map { _mapper.transformEntityToDomain(entity: $0) }
                        .eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
}
