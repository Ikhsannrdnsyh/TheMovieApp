//
//  APIContants.swift
//  Core
//
//  Created by Mochamad Ikhsan Nurdiansyah on 16/03/25.
//

import Foundation

public struct APIConstants {
    public static let baseUrl = "https://api.themoviedb.org/3/"
    public static let basePosterUrl = "https://image.tmdb.org/t/p/w500/"
    public static let baseBackdropUrl = "https://image.tmdb.org/t/p/original/"
    
    public static var apiKey: String {
        guard let key = Bundle.main.infoDictionary?["API_KEY"] as? String, !key.isEmpty else {
            fatalError("API Key is missing! Please add it to Info.plist.")
        }
        return key
    }
}
