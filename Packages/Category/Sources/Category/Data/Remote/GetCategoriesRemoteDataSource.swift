//
//  GetCategoriesRemoteDataSource.swift
//  Category
//
//  Created by Mochamad Ikhsan Nurdiansyah on 16/03/25.
//


import Core
import Alamofire
import Combine
import Foundation

public struct GetCategoriesRemoteDataSource: DataSource {
    
    public typealias Request = MovieCategoryType
    public typealias Response = [CategoryResponse]
    
    public init() {}
    
    /// Fungsi generik untuk request API
    private func performRequest<T: Decodable & Sendable>(url: String) -> AnyPublisher<T, Error> {
        return Future<T, Error> { completion in
            print("🔍 Requesting API: \(url)") // Logging untuk debugging
            
            AF.request(url)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let data):
                        print("API Response Success") // Debugging
                        completion(.success(data))
                    case .failure(let error):
                        print("API Request Failed: \(error.localizedDescription)") // Debugging
                        completion(.failure(URLError(.badServerResponse)))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    /// Eksekusi request berdasarkan kategori film
    public func execute(request: MovieCategoryType?) -> AnyPublisher<[CategoryResponse], Error> {
        guard let category = request else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        let url = category.endpoint + "?api_key=\(APIConstants.apiKey)"
        
        return performRequest(url: url)
            .map { (response: CategoriesResponse) in response.movies }
            .eraseToAnyPublisher()
    }
}
