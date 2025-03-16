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
    
    var endpoint: String {
        return "\(APIConstants.baseUrl)movie/\(self.rawValue)"
    }
}
