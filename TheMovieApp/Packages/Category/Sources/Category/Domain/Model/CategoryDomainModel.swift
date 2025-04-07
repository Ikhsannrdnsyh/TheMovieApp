//
//  CategoryDomainModel.swift
//  Category
//
//  Created by Mochamad Ikhsan Nurdiansyah on 16/03/25.
//

import Foundation
import Core

public struct MovieResp: Equatable, Decodable {
    let results: [CategoryDomainModel]
}

public struct CategoryDomainModel: Equatable, Decodable, Identifiable, Hashable {
    public let id: Int32
    public let title: String
    public let overview: String
    public let posterPath: String?
    public let backdropPath: String?
    public let category: MovieCategoryType?
    public let releaseDate: Date?
    public let runtime: Int32?
    public let rating: Double
    public let voteCount: Int32
    public var isFavorite: Bool
    public let genres: [MovieGenre]?
    public let genreIds: [Int]?
    
    public init(
            id: Int32,
            title: String,
            overview: String,
            posterPath: String?,
            backdropPath: String?,
            category: MovieCategoryType?,
            releaseDate: Date?,
            runtime: Int32?,
            rating: Double,
            voteCount: Int32,
            isFavorite: Bool?,
            genres: [MovieGenre]?,
            genreIds: [Int]?
            
        ) {
            self.id = id
            self.title = title
            self.overview = overview
            self.posterPath = posterPath
            self.backdropPath = backdropPath
            self.category = category
            self.releaseDate = releaseDate
            self.runtime = runtime
            self.rating = rating
            self.voteCount = voteCount
            self.isFavorite = isFavorite ?? false
            self.genres = genres
            self.genreIds = genreIds
        }
    
    
    public var posterURL: URL? {
        guard let urlString = ImageUrlHelper.buildPosterUrl(from: posterPath) else { return nil }
        return URL(string: urlString)
    }

    public var backdropURL: URL? {
        guard let urlString = ImageUrlHelper.buildBackdropUrl(from: backdropPath) else { return nil }
        return URL(string: urlString)
    }

    
    public var yearText: String {
        guard let releaseDate = releaseDate else {
            return "n/a"
        }
        return DateHelper.formatDateToString(releaseDate) ?? "n/a"
    }
    
    public var durationText: String {
        guard let runtime = runtime, runtime > 0 else {
            return "n/a"
        }
        return DateHelper.durationFormatter.string(from: TimeInterval(runtime) * 60) ?? "n/a"
    }
    
    public var ratingText: String {
        let rating = Int(rating)
        return (0..<rating).reduce("") { acc, _ in acc + "★" }
    }
    
    public var scoreText: String {
        ratingText.isEmpty ? "n/a" : "\(ratingText.count)/10"
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: CategoryDomainModel, rhs: CategoryDomainModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    public var genreText: String {
        genres?.map { $0.name }.joined(separator: ", ") ?? "n/a"
    }

}

public struct MovieGenre: Equatable, Decodable {
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
}
