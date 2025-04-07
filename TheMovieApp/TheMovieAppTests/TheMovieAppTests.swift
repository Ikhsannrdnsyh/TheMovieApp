//
//  TheMovieAppTests.swift
//  TheMovieAppTests
//
//  Created by Mochamad Ikhsan Nurdiansyah on 04/03/25.
//

import XCTest
@testable import TheMovieApp
@testable import Category

final class MovieModelTests: XCTestCase {

    func testMovieModelInitialization() {
        let movie = CategoryDomainModel(
            id: 950396,
            title: "The Gorge",
            overview: "Two highly trained",
            posterPath: "/7iMBZzVZtG0oBug4TfqDb9ZxAOa.jpg",
            backdropPath: "/9nhjGaFLKtddDPtPaX5EmKqsWdH.jpg",
            category: MovieCategoryType.nowPlaying,
            releaseDate: Date(timeIntervalSince1970: 1739379600),
            runtime: 148,
            rating: 8.8,
            voteCount: 1575,
            isFavorite: false,
            genres: [MovieGenre(name: "Action"), MovieGenre(name: "Sci-Fi")],
            genreIds: [1]
        )

        XCTAssertEqual(movie.id, 950396)
        XCTAssertEqual(movie.title, "The Gorge")
        XCTAssertEqual(movie.overview, "Two highly trained")
        XCTAssertEqual(movie.posterPath, "/7iMBZzVZtG0oBug4TfqDb9ZxAOa.jpg")
        XCTAssertEqual(movie.backdropPath, "/9nhjGaFLKtddDPtPaX5EmKqsWdH.jpg")
        XCTAssertEqual(movie.runtime, 148)
        XCTAssertEqual(movie.rating, 8.8)
        XCTAssertEqual(movie.voteCount, 1575)
        XCTAssertEqual(movie.isFavorite, false)
        XCTAssertEqual(movie.genres?.count, 2)
        XCTAssertEqual(movie.genres?.first?.name, "Action")
    }

}
