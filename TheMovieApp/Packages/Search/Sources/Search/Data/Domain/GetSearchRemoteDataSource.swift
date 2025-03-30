//
//  GetSearchRemoteDataSource.swift
//  Search
//
//  Created by Mochamad Ikhsan Nurdiansyah on 26/03/25.
//

//
//  GetSearchRemoteDataSource.swift
//  Search
//
//  Created by Mochamad Ikhsan Nurdiansyah on 26/03/25.
//

import Combine
import Foundation
import Core
import Category

public struct GetSearchRemoteDataSource: DataSource {
    public typealias Request = String
    public typealias Response = [CategoryResponse] 
    
    private let baseUrl: String
    
    public init(baseUrl: String = APIConstants.baseUrl) {
        self.baseUrl = baseUrl
    }
    
    public func execute(request: String?) -> AnyPublisher<[CategoryResponse], Error> {
        guard let query = request, !query.isEmpty else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        let urlString = "\(baseUrl)search/movie?query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&api_key=\(APIConstants.apiKey)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { $0 as Error }
            .flatMap { (data, response) -> AnyPublisher<[CategoryResponse], Error> in
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    return Fail(error: URLError(.badServerResponse))
                        .eraseToAnyPublisher()
                }
                
                return Just(data)
                    .decode(type: CategoriesResponse.self, decoder: JSONDecoder())
                    .map { $0.movies }
                    .mapError { $0 as Error }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
