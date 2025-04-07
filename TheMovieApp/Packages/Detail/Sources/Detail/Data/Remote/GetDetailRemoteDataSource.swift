//
//  GetDetailRemoteDataSource.swift
//  Detail
//
//  Created by Mochamad Ikhsan Nurdiansyah on 23/03/25.
//

import Core
import Category
import Alamofire
import Combine
import Foundation

public struct GetDetailRemoteDataSource: DataSource {
    
    public typealias Request = Int
    public typealias Response = CategoryResponse
    
    public init() {}
    
    /// Fungsi generik untuk request API
    private func performRequest<T: Decodable & Sendable>(url: String) -> AnyPublisher<T, Error> {
        return Future<T, Error> { completion in
            print("🔍 Requesting API: \(url)") // Logging untuk debugging
            
            AF.request(url)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    print("📡 Status Code: \(response.response?.statusCode ?? 0)")
                    
                    switch response.result {
                    case .success(let data):
                        print("✅ API Response Success: \(T.self)")
                        completion(.success(data))
                    case .failure(let error):
                        print("❌ API Request Failed: \(error.localizedDescription)")
                        print("🧾 Full Response: \(String(data: response.data ?? Data(), encoding: .utf8) ?? "-")")
                        completion(.failure(URLError(.badServerResponse)))
                    }
                }
        }
        .eraseToAnyPublisher()
    }

    
    /// Eksekusi request untuk mendapatkan detail film berdasarkan ID
    public func execute(request: Int?) -> AnyPublisher<CategoryResponse, Error> {
        guard let movieId = request else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        let url = "\(APIConstants.baseUrl)movie/\(movieId)?api_key=\(APIConstants.apiKey)"
        
        return performRequest(url: url)
    }
}
