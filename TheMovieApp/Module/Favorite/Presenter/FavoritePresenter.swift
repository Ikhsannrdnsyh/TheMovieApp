//
//  FavoritePresenter.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 01/01/25.
//

import Combine
import SwiftUI

class FavoritePresenter: ObservableObject {
    private let router: FavoriteRouter
    private let favoriteUseCase: FavoriteUseCase
    private var cancellables = Set<AnyCancellable>()
    
    @Published var movies: [MovieModel] = []
    @Published var isLoading: Bool = false
    @Published var error: String? = nil
    
    init(router: FavoriteRouter, favoriteUseCase: FavoriteUseCase) {
        self.router = router
        self.favoriteUseCase = favoriteUseCase
    }
    
    func showMovieFavorite() {
        isLoading = true
        error = nil
        
        favoriteUseCase.getFavoriteMovies()
            .receive(on: DispatchQueue.main) 
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    print("Successfully fetched favorite movies")
                case .failure(let failure):
                    self.error = failure.localizedDescription
                    print("Error fetching favorites: \(failure.localizedDescription)")
                }
            }, receiveValue: { movies in
                self.movies = movies
                print("Fetched \(movies.count) favorite movies")
            })
            .store(in: &cancellables)
    }

    
    func linkBuilder<Content: View>(
        for movie: MovieModel,
        @ViewBuilder content: () -> Content
    ) -> some View {
        NavigationLink(
            destination: router.makeDetailView(for: movie)
                .onAppear {
                    self.isLoading = true
                }
                .onDisappear {
                    self.isLoading = false
                }
        ) {
            content()
        }
        .simultaneousGesture(TapGesture().onEnded {
            print("Navigating to detail for movie: \(movie.title)")
        })
    }
}
