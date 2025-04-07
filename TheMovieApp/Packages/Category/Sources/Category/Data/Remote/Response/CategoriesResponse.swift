//
//  CategoriesResponse.swift
//  Category
//
//  Created by Mochamad Ikhsan Nurdiansyah on 16/03/25.
//

import Foundation

public struct CategoriesResponse: Decodable, Sendable {
    public let movies: [CategoryResponse]
    
    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

public struct CategoryResponse: Decodable, Sendable {
    
    public let id: Int32?
    public let title: String?
    public let overview: String?
    public let posterPath: String?
    public let backdropPath: String?
    public let releaseDate: String?
    public let category: String?
    public let rating: Double?
    public let runtime: Int?
    public let voteCount: Int32?
    public let genres: [GenreResponse]?
    public let genreIds: [Int]?
    public var isFavorite: Bool?
    
    
    public enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case rating = "vote_average"
        case voteCount = "vote_count"
        case runtime
        case category
        case genres
        case genreIds = "genre_ids"
        case isFavorite
    }
}
public struct GenreResponse: Decodable, Sendable {
    public let id: Int?
    public let name: String?
}

