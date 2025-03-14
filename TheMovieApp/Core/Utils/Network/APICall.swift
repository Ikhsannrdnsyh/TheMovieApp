//
//  APICall.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 28/12/24.
//

import Foundation

struct API {
    
    static let baseUrl = "https://api.themoviedb.org/3/"
    static let apiKey: String = {
        guard let key = Bundle.main.infoDictionary?["API_KEY"] as? String, !key.isEmpty else {
            print("API Key is missing, using default API key.")
            return "DEFAULT_API_KEY"
        }
        print("API Key Loaded: \(key.prefix(4))**** (partially hidden)")
        return key
    }()
    static let basePosterUrl = "https://image.tmdb.org/t/p/w500/"
    static let baseBackdropUrl = "https://image.tmdb.org/t/p/original/"
    
}

protocol Endpoint {
    
    var url: String { get }
    
}
enum Endpoints {
    enum Gets: Endpoint {
        case nowPlaying
        case popularMovies
        case movieDetail(id: Int)
        
        public var url: String {
            switch self {
            case .nowPlaying:
                return "\(API.baseUrl)movie/now_playing?api_key=\(API.apiKey)"
            case .popularMovies:
                return "\(API.baseUrl)movie/popular?api_key=\(API.apiKey)"
            case .movieDetail(let id):
                return "\(API.baseUrl)movie/\(id)/credits?api_key=\(API.apiKey)"
            }
        }
    }
}
