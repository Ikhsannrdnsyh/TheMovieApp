//
//  GetSearchRepository.swift
//  Search
//
//  Created by Mochamad Ikhsan Nurdiansyah on 26/03/25.
//
import Combine
import Core
import Category
import Foundation

public struct GetSearchRepository<
    SearchLocale: SearchLocaleDataSource,
    SearchRemote: DataSource,
    Transformer: Mapper
>: Repository where
SearchLocale.Request == String,
SearchLocale.Response == [MoviesEntity],
SearchRemote.Request == String,
SearchRemote.Response == [CategoryResponse],
Transformer.Response == [CategoryResponse],
Transformer.Entity == [MoviesEntity],
Transformer.Domain == [CategoryDomainModel] {

    public typealias Request = String
    public typealias Response = [CategoryDomainModel]

    private let localeDataSource: SearchLocale
    private let remoteDataSource: SearchRemote
    private let mapper: Transformer

    public init(
        localeDataSource: SearchLocale,
        remoteDataSource: SearchRemote,
        mapper: Transformer
    ) {
        self.localeDataSource = localeDataSource
        self.remoteDataSource = remoteDataSource
        self.mapper = mapper
    }

    public func execute(request: String?) -> AnyPublisher<[CategoryDomainModel], Error> {
        guard let query = request, !query.isEmpty else {
            return Fail(error: NSError(domain: "InvalidRequest", code: 400, userInfo: [NSLocalizedDescriptionKey: "Query tidak boleh kosong"]))
                .eraseToAnyPublisher()
        }
        
        return localeDataSource.searchMovie(query: query)
            .flatMap { entities -> AnyPublisher<[CategoryDomainModel], Error> in
                let domainModels = mapper.transformEntityToDomain(entity: entities)
                print("🎬 Converted Movies: \(domainModels)") // Debug hasil konversi

                if !domainModels.isEmpty {
                    return Just(domainModels)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                } else {
                    return self.fetchFromRemote(query: query)
                }
            }
            .catch { _ in
                return self.fetchFromRemote(query: query)
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchFromRemote(query: String) -> AnyPublisher<[CategoryDomainModel], Error> {
        return remoteDataSource.execute(request: query)
            .map { response in
                return mapper.transformResponseToEntity(response: response, category: "search")
            }
            .map { entities in
                return mapper.transformEntityToDomain(entity: entities)
            }
            .catch { _ in
                return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
