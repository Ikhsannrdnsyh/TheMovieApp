//
//  GetFavoriteRemoteDataSource.swift
//  Favorites
//
//  Created by Mochamad Ikhsan Nurdiansyah on 25/03/25.
//

import Foundation
import Combine
import Core
import Category
import Alamofire

public struct GetFavoriteRemoteDataSource: DataSource {
    public typealias Request = Int
    public typealias Response = [CategoryResponse]
    
    public init() {}
    
    public func execute(request: Int?) -> AnyPublisher<[CategoryResponse], Error> {
        guard let userId = request else {
            return Fail(error: NSError(domain: "InvalidRequest", code: 400, userInfo: [NSLocalizedDescriptionKey: "User ID tidak valid"]))
                .eraseToAnyPublisher()
        }
        
        let url = "\(APIConstants.baseUrl)user/\(userId)/favorites"
        let parameters: [String: String] = [
            "api_key": APIConstants.apiKey,
            "language": "en-US"
        ]
        
        return Future<[CategoryResponse], Error> { promise in
            AF.request(url, parameters: parameters)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: CategoriesResponse.self) { response in
                    switch response.result {
                    case .success(let data):
                        var movies = data.movies
                        movies.indices.forEach { movies[$0].isFavorite = true }
                        promise(.success(movies))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
        
    }
}
