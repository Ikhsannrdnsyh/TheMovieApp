//
//  FavoriteView.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 03/03/25.
//

import Foundation
import SwiftUI
import Category
import Favorites
import Core
import Common

struct FavoriteView: View {
    @ObservedObject var presenter: GetFavoritePresenter<Int, [CategoryDomainModel], Interactor<Int, [CategoryDomainModel], GetFavoritesRepository<GetFavoriteLocaleDataSource, GetFavoriteRemoteDataSource>>>
    
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    private let router = FavoriteRouter()
    
    var body: some View {
        NavigationView {
            VStack {
                if presenter.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if presenter.movies?.isEmpty ?? true {
                    emptyStateView
                } else {
                    movieGridView
                }
            }
            .navigationTitle("favoritTitle".localized(identifier: "com.Ikhsan.TheMovieApp"))
            .onAppear {
                presenter.getFavoriteMovies()
            }
            .refreshable {
                presenter.getFavoriteMovies()
            }
        }
    }
    
    // MARK: - Grid View
    private var movieGridView: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                let uniqueMovies = Array(Set(presenter.movies ?? []))

                ForEach(uniqueMovies, id: \.id) { movie in
                    NavigationLink(destination: router.makeDetailView(for: movie, category: .search)) {
                        NowPlayingMovieRow(movies: movie)
                            .contentShape(Rectangle())
                    }
                }
            }
            .padding()
            .animation(.easeInOut, value: presenter.movies)
            .refreshable {
                presenter.getFavoriteMovies()
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("FavoriteStatusChanged"))) { _ in
                print("🔄 Refreshing favorite movies")
                presenter.getFavoriteMovies()
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
            
            Text("noFavoriteMovie".localized(identifier: "com.Ikhsan.TheMovieApp"))
                .font(.headline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: {
                presenter.getFavoriteMovies()
            }) {
                Label("reload".localized(identifier: "com.Ikhsan.TheMovieApp"), systemImage: "arrow.clockwise")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}
