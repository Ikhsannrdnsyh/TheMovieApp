//
//  SearchView.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 31/12/24.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var presenter: SearchPresenter
    
    var body: some View {
        VStack {
            SearchBar(query: $presenter.query)
            
            if presenter.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if presenter.movies.isEmpty {
                Text("No results found")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(presenter.movies, id: \.id) { movie in
                            presenter.linkBuilder(for: movie) {
                                NowPlayingMovieRow(movies: movie)
                                    .contentShape(Rectangle())
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .onChange(of: presenter.query) { _ in
            presenter.search()
        }
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SearchBar: View {
    @Binding var query: String
    
    var body: some View {
        HStack {
            TextField("Search movies...", text: $query)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .padding(.vertical, 8)
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}
