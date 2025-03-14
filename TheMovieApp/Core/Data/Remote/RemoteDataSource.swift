//
//  RemoteDataSource.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 29/12/24.
//

import Foundation
import Alamofire
import Combine

protocol RemoteDataSourceProtocol: AnyObject {
    
    func getNowPlayingMovies() -> AnyPublisher<MoviesResponse, Error>
    func getPopularMovies() -> AnyPublisher<MoviesResponse, Error>
    func getMovieDetail(by id: Int) -> AnyPublisher<MovieResponse, Error>
    
}

final class RemoteDataSource: NSObject {
    static let sharedInstance: RemoteDataSource = RemoteDataSource()
    
    private override init() {}
    
    private func performRequest<T: Decodable>(url: String, parameters: [String: Any]? = nil) -> AnyPublisher<T, Error> {
        return Future<T, Error> { completion in
            AF.request(url, parameters: parameters)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let data):
                        completion(.success(data))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}

extension RemoteDataSource: RemoteDataSourceProtocol {
    func getNowPlayingMovies() -> AnyPublisher<MoviesResponse, any Error> {
        let url = "\(API.baseUrl)movie/now_playing"
        let parameters: [String: Any] = [
            "api_key": API.apiKey,
            "language": "en-US"
        ]
        return performRequest(url: url, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
    func getPopularMovies() -> AnyPublisher<MoviesResponse, any Error> {
        let url = "\(API.baseUrl)movie/popular"
        let parameters: [String: Any] = [
            "api_key": API.apiKey,
            "language": "en-US"
        ]
        return performRequest(url: url, parameters: parameters)
            .eraseToAnyPublisher()
    }
    func getMovieDetail(by id: Int) -> AnyPublisher<MovieResponse, any Error> {
            let url = "\(API.baseUrl)movie/\(id)"
            let parameters: [String: Any] = [
                "api_key": API.apiKey,
                "language": "en-US"
            ]
            return performRequest(url: url, parameters: parameters)
                .eraseToAnyPublisher()
        }
}
