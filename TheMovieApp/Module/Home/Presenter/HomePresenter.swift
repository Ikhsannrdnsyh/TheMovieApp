//
//  HomePresenter.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 29/12/24.
//

import Foundation
import SwiftUI
import Combine

class HomePresenter: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []

    private let homeUseCase: HomeUseCase
    private let router: HomeRouter

    @Published var nowPlayingMovies: [MovieModel] = []
    @Published var isLoadingNowPlaying: Bool = false
    @Published var nowPlayingError: String? = nil

    @Published var popularMovies: [MovieModel] = []
    @Published var isLoadingPopular: Bool = false
    @Published var popularError: String? = nil
    @Published var selectedMovie: MovieModel? = nil

    init(homeUseCase: HomeUseCase, router: HomeRouter) {
        self.homeUseCase = homeUseCase
        self.router = router
    }

    func getMoviesNowPlaying() {
        isLoadingNowPlaying = true
        nowPlayingError = nil
        homeUseCase.getNowPlayingMovies()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.nowPlayingError = String(describing: completion)
                case .finished:
                    self.isLoadingNowPlaying = false
                }
            }, receiveValue: { movies in
                self.nowPlayingMovies = movies
            }).store(in: &cancellables)
    }

    func getMoviesPopular() {
        isLoadingPopular = true
        popularError = nil
        homeUseCase.getPopularMovies()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.popularError = String(describing: completion)
                case .finished:
                    self.isLoadingPopular = false
                }
            }, receiveValue: { movies in
                self.popularMovies = movies
            }).store(in: &cancellables)
    }

    func selectedMovie(at index: Int, in type: MovieType) {
        let movies: [MovieModel] = (type == .nowPlaying) ? nowPlayingMovies : popularMovies
        guard index >= 0 && index < movies.count else {
            return
        }
        selectedMovie = movies[index]
    }

    func linkBuilder<Content: View>(
        for movie: MovieModel,
        @ViewBuilder content: () -> Content
    ) -> some View {
        NavigationLink(
            destination: router.makeDetailView(for: movie)
        ) {
            content()
        }
    }

    enum MovieType {
        case nowPlaying
        case popular
    }
}
