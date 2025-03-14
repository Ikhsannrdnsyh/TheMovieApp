//
//  FavoriteView.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 03/03/25.
//

import Foundation
import SwiftUI

struct FavoriteView: View {
    @ObservedObject var presenter: FavoritePresenter
    
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            VStack {
                if presenter.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if presenter.movies.isEmpty {
                    emptyStateView
                } else {
                    movieGridView
                }
            }
            .navigationTitle("Favorite Movies")
            .onAppear {
                presenter.showMovieFavorite()
            }
        }
    }
    
    // MARK: - Grid View
    private var movieGridView: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(presenter.movies, id: \.id) { movie in
                    presenter.linkBuilder(for: movie) {
                        NowPlayingMovieRow(movies: movie)
                            .contentShape(Rectangle())
                    }
                }
            }
            .padding()
            .animation(.easeInOut, value: presenter.movies)
            .refreshable {
                presenter.showMovieFavorite()
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack {
            Image(systemName: "heart.slash.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
            
            Text("You Haven't Favorite Movies")
                .font(.headline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: {
                presenter.showMovieFavorite()
            }) {
                Label("Reload", systemImage: "arrow.clockwise")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}
