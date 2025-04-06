//
//  GetDetailRepository.swift
//  Detail
//
//  Created by Mochamad Ikhsan Nurdiansyah on 23/03/25.
//

import Combine
import Core
import Category
import Foundation

public struct GetDetailRepository<
    DetailLocale: DetailLocaleDataSource,
    DetailRemote: DataSource,
    Transformer: Mapper
>: Repository where
DetailLocale.Request == Int,
DetailLocale.Response == MoviesEntity,
DetailRemote.Request == Int,
DetailRemote.Response == [CategoryResponse],
Transformer.Response == [CategoryResponse],
Transformer.Entity == [MoviesEntity],
Transformer.Domain == [CategoryDomainModel] {
    
    public typealias Request = Int
    public typealias Response = CategoryDomainModel
    
    private let localeDataSource: DetailLocale
    private let remoteDataSource: DetailRemote
    private let mapper: Transformer
    private let categoryType: MovieCategoryType
    
    public init(
        localeDataSource: DetailLocale,
        remoteDataSource: DetailRemote,
        mapper: Transformer,
        categoryType: MovieCategoryType
    ) {
        self.localeDataSource = localeDataSource
        self.remoteDataSource = remoteDataSource
        self.mapper = mapper
        self.categoryType = categoryType
    }
    
    public func execute(request: Int?) -> AnyPublisher<CategoryDomainModel, Error> {
        print("🟢 Debug: Request Masuk - \(String(describing: request))") // Debugging
        
        guard let movieId = request else {
            print("Error: Request tidak valid (nil)")
            return Fail(error: NSError(domain: "InvalidRequest", code: 400, userInfo: [NSLocalizedDescriptionKey: "Request tidak valid"]))
                .eraseToAnyPublisher()
        }
        
        print("Debug: Request Diterima - ID: \(movieId)")
        
        return localeDataSource.getMovieDetail(id: movieId)
            .flatMap { entity -> AnyPublisher<CategoryDomainModel, Error> in
                let domainModels = mapper.transformEntityToDomain(entity: [entity])
                if let domainModel = domainModels.first {
                    return Just(domainModel)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                } else {
                    print("Error: Data di lokal tidak ditemukan, mengambil dari remote")
                    return self.fetchFromRemote(movieId: movieId)
                }
            }
            .catch { _ in
                print("Error: Gagal mengambil dari lokal, mencoba remote")
                return self.fetchFromRemote(movieId: movieId)
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchFromRemote(movieId: Int) -> AnyPublisher<CategoryDomainModel, Error> {
        return remoteDataSource.execute(request: movieId)
            .map { response in
                let entities = mapper.transformResponseToEntity(
                    response: response,
                    category: self.categoryType.rawValue.lowercased()
                )
                return entities
            }
            .tryMap { entities in
                let domainModels = mapper.transformEntityToDomain(entity: entities)
                
                if let domainModel = domainModels.first {
                    return domainModel
                } else {
                    throw NSError(
                        domain: "EmptyData",
                        code: 404,
                        userInfo: [NSLocalizedDescriptionKey: "Data tidak ditemukan dari API"]
                    )
                }
            }
            .eraseToAnyPublisher()
    }
    
}
