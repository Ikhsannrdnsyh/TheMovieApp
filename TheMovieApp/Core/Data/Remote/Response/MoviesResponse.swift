//
//  MoviesResponse.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 28/12/24.
//

import Foundation
struct MoviesResponse: Decodable {
    let movies: [MovieResponse]
    
    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

struct MovieResponse: Decodable {
    
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
struct GenreResponse: Decodable {
    let id: Int?
    let name: String?
}
