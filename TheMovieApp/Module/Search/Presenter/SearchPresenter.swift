//
//  SearchPresenter.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 31/12/24.
//

import Combine
import SwiftUI

class SearchPresenter: ObservableObject {
    private let router: SearchRouter
    private let searchUseCase: SearchUseCase
    private var cancellables = Set<AnyCancellable>()
    
    @Published var query: String = ""
    @Published var searchError: String? = nil
    @Published var movies: [MovieModel] = []
    @Published var isLoading: Bool = false
    
    init(searchUseCase: SearchUseCase, router: SearchRouter) {
        self.searchUseCase = searchUseCase
        self.router = router
    }
    
    func search() {
        guard !query.isEmpty else {
            self.movies = []
            return
        }
        
        isLoading = true
        searchUseCase.searchMovies(query: query)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    self.searchError = error.localizedDescription
                    self.movies = []
                case .finished:
                    self.isLoading = false
                }
            }, receiveValue: { [weak self] movies in
                self?.movies = movies 
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
