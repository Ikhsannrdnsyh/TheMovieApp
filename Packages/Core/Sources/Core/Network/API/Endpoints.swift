//
//  Endpoints.swift
//  Core
//
//  Created by Mochamad Ikhsan Nurdiansyah on 16/03/25.
//

import Foundation

public protocol Endpoint {
    var url: String { get }
}

public enum Endpoints {
    public enum Movie: Endpoint {
        case nowPlaying
        case popularMovies
        case movieDetail(id: Int)
        
        public var url: String {
            switch self {
            case .nowPlaying:
                return "\(APIConstants.baseUrl)movie/now_playing?api_key=\(APIConstants.apiKey)"
            case .popularMovies:
                return "\(APIConstants.baseUrl)movie/popular?api_key=\(APIConstants.apiKey)"
            case .movieDetail(let id):
                return "\(APIConstants.baseUrl)movie/\(id)?api_key=\(APIConstants.apiKey)"
            }
        }
    }
}
