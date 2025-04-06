//
//  GenreMapper.swift
//  Category
//
//  Created by Mochamad Ikhsan Nurdiansyah on 06/04/25.
//

public struct GenreStorage : Sendable {
    public static let shared = GenreStorage()

    public private(set) var genres: [Int: String] = [:]

    public mutating func setGenres(_ genreList: [GenreResponse]) {
        for genre in genreList {
            if let id = genre.id, let name = genre.name {
                genres[id] = name
            }
        }
    }

    public func name(for id: Int) -> String? {
        return genres[id]
    }
}
