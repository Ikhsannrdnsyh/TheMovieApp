//
//  MovieCategoryType.swift
//  Category
//
//  Created by Mochamad Ikhsan Nurdiansyah on 16/03/25.
//

import Core

public enum MovieCategoryType: String {
    case nowPlaying = "now_playing"
    case popular = "popular"
    case search = "search"
    
    var endpoint: String {
        switch self {
        case .search:
            return "\(APIConstants.baseUrl)search/movie"
        default:
            return "\(APIConstants.baseUrl)movie/\(self.rawValue)"
        }
    }
}


