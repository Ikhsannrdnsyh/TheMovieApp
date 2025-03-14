//
//  MovieModel.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 24/12/24.
//

import Foundation

struct MovieResp: Equatable, Decodable {
    let results: [MovieModel]
}

struct MovieModel: Equatable, Decodable, Identifiable, Hashable {
    let id: Int32
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: Date?
    let runtime: Int32?
    let rating: Double
    let voteCount: Int32
    var isFavorite: Bool
    let genres: [MovieGenre]?
    
    var yearText: String {
        guard let releaseDate = releaseDate else {
            return "n/a"
        }
        return DateHelper.formatDateToString(releaseDate) ?? "n/a"
    }
    
    var durationText: String {
        guard let runtime = runtime, runtime > 0 else {
            return "n/a"
        }
        return DateHelper.durationFormatter.string(from: TimeInterval(runtime) * 60) ?? "n/a"
    }
    
    var ratingText: String {
        let rating = Int(rating)
        return (0..<rating).reduce("") { acc, _ in acc + "★" }
    }
    
    var scoreText: String {
        ratingText.isEmpty ? "n/a" : "\(ratingText.count)/10"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MovieModel, rhs: MovieModel) -> Bool {
        return lhs.id == rhs.id
    }
}

struct MovieGenre: Equatable, Decodable {
    let name: String
}
