//
//  CategoriesResponse.swift
//  Category
//
//  Created by Mochamad Ikhsan Nurdiansyah on 16/03/25.
//

import Foundation

public struct CategoriesResponse: Decodable, Sendable {
    let movies: [CategoryResponse]
    
    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

public struct CategoryResponse: Decodable, Sendable {
    
    let id: Int32?
    let title: String?
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let rating: Double?
    let runtime: Int32?
    let voteCount: Int32?
    let genres: [GenreResponse]?
    var isFavorite: Bool?
    
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case rating = "vote_average"
        case voteCount = "vote_count"
        case runtime
        case genres
        case isFavorite
    }
}
public struct GenreResponse: Decodable, Sendable {
    let id: Int?
    let name: String?
}
