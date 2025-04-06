//
//  SearchView.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 31/12/24.
//

import SwiftUI
import Search
import Category
import Core
import Common

typealias SearchPresenterPars = GetSearchPresenter<
    String,
    [CategoryDomainModel],
    Interactor<String, [CategoryDomainModel], GetSearchRepository<GetSearchLocaleDataSource, GetSearchRemoteDataSource, CategoryTransformer>>
>

struct SearchView: View {
    @StateObject var presenter: SearchPresenterPars
    private let router = SearchRouter()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(query: $presenter.query, onClear: {
                    presenter.movies = []
                })
                
                if presenter.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if presenter.query.isEmpty || presenter.movies.isEmpty {
                    
                    VStack {
                        Image(systemName: "film")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                        Text("noResult".localized(identifier: "com.Ikhsan.TheMovieApp"))
                            .foregroundColor(.gray)
                            .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            let uniqueMovies = Array(Set(presenter.movies))
                            ForEach(uniqueMovies, id: \.id) { movie in
                                NavigationLink(destination: router.makeDetailView(for: movie, category: .search)) {
                                    NowPlayingMovieRow(movies: movie)
                                        .contentShape(Rectangle())
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("searchTitle".localized(identifier: "com.Ikhsan.TheMovieApp"))
            .navigationBarTitleDisplayMode(.large)
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("FavoriteStatusChanged"))) { _ in
                print("🔄 Refreshing search results after favorite toggle")
                presenter.executeSearch(query: presenter.query)
            }
        }
    }
}

struct SearchBar: View {
    @Binding var query: String
    var onClear: () -> Void

    var body: some View {
        HStack {
            TextField("searchMovie".localized(identifier: "com.Ikhsan.TheMovieApp"), text: $query)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .padding(.vertical, 8)
                .onChange(of: query) { newValue in
                    if newValue.isEmpty {
                        DispatchQueue.main.async {
                            onClear()
                        }
                    }
                }
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}
