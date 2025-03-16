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
    public let releaseDate: Date?
    public let runtime: Int32?
    public let rating: Double
    public let voteCount: Int32
    public var isFavorite: Bool
    public let genres: [MovieGenre]?
    
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
}

public struct MovieGenre: Equatable, Decodable {
    let name: String
}
