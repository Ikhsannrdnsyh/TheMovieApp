//
//  GetListPresenterTest.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 30/03/25.
//

import XCTest
import Combine
@testable import Category
@testable import Core

final class GetListPresenterTests: XCTestCase {
    
    private var presenter: GetListPresenter<MovieCategoryType, CategoryDomainModel, MockUseCase>!
    private var useCase: MockUseCase!
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        useCase = MockUseCase()
        presenter = GetListPresenter(useCase: useCase)
    }
    
    override func tearDown() {
        presenter = nil
        useCase = nil
        super.tearDown()
    }
    
    func test_getNowPlayingMovies_Success() {
        let expectation = expectation(description: "Fetch now playing movies successfully")
        
        useCase.shouldReturnError = false
        presenter.getNowPlayingMovies()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(self.presenter.isLoadingNowPlaying)
            XCTAssertNil(self.presenter.nowPlayingError)
            XCTAssertEqual(self.presenter.nowPlayingMovies.count, 2)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_getNowPlayingMovies_Failure() {
        let expectation = expectation(description: "Fetch now playing movies failed")
        
        useCase.shouldReturnError = true
        presenter.getNowPlayingMovies()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(self.presenter.isLoadingNowPlaying)
            XCTAssertNotNil(self.presenter.nowPlayingError)
            XCTAssertEqual(self.presenter.nowPlayingMovies.count, 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_getPopularMovies_Success() {
        let expectation = expectation(description: "Fetch popular movies successfully")
        
        useCase.shouldReturnError = false
        presenter.getPopularMovies()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(self.presenter.isLoadingPopular)
            XCTAssertNil(self.presenter.popularError)
            XCTAssertEqual(self.presenter.popularMovies.count, 2)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_getPopularMovies_Failure() {
        let expectation = expectation(description: "Fetch popular movies failed")
        
        useCase.shouldReturnError = true
        presenter.getPopularMovies()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(self.presenter.isLoadingPopular)
            XCTAssertNotNil(self.presenter.popularError)
            XCTAssertEqual(self.presenter.popularMovies.count, 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}

// Mock UseCase
class MockUseCase: UseCase {
    typealias Request = MovieCategoryType
    typealias Response = [CategoryDomainModel]
    
    var shouldReturnError = false
    
    func execute(request: MovieCategoryType?) -> AnyPublisher<[CategoryDomainModel], Error> {
        if shouldReturnError {
            return Fail(error: NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch data"]))
                .eraseToAnyPublisher()
        } else {
            let movies = [
                CategoryDomainModel(
                    id: 1,
                    title: "Movie 1",
                    overview: "Overview 1",
                    posterPath: nil,
                    backdropPath: nil,
                    category: MovieCategoryType.nowPlaying,
                    releaseDate: nil,
                    runtime: nil,
                    rating: 7.5,
                    voteCount: 100,
                    isFavorite: false,
                    genres: nil, genreIds: [0]
                ),
                CategoryDomainModel(
                    id: 2,
                    title: "Movie 2",
                    overview: "Overview 2",
                    posterPath: nil,
                    backdropPath: nil,
                    category: MovieCategoryType.nowPlaying,
                    releaseDate: nil,
                    runtime: nil,
                    rating: 8.0,
                    voteCount: 200,
                    isFavorite: true,
                    genres: nil, genreIds: [0]
                )
            ]

            return Just(movies)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
