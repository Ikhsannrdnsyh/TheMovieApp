//
//  DetailView.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 29/12/24.
//

import SwiftUI
import CachedAsyncImage

struct DetailView: View {
    @ObservedObject var presenter: DetailPresenter
    
    var body: some View {
        ZStack {
            if presenter.isLoading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
                    .background(Color.white, alignment: .center)
                    .cornerRadius(10)
            } else if let error = presenter.error {
                VStack {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                    Button("Retry") {
                        presenter.getMovieDetail()
                    }
                    .padding()
                }
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
            } else if let movie = presenter.movie {
                MovieDetailContentView(movie: movie)
                    .padding()
            }
        }
        .navigationBarTitle(presenter.movie?.title ?? "", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            presenter.toggleFavoriteStatus()
        }) {
            Image(systemName: presenter.isFavorite ? "heart.fill" : "heart")
                .foregroundColor(.red)
                .font(.title)
        })
        .onAppear {
            if presenter.movie == nil {
                presenter.getMovieDetail()
            } else {
                presenter.isFavorite = presenter.movie?.isFavorite ?? false
            }
        }
    }
}
