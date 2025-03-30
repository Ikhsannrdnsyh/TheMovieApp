//
//  DetailView.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 29/12/24.
//

import SwiftUI
import CachedAsyncImage
import Category
import Core
import Detail
import Common

struct DetailView: View {
    @ObservedObject var presenter: GetDetailPresenter<Int, CategoryDomainModel, Interactor<Int, CategoryDomainModel, GetDetailRepository<GetDetailLocaleDataSource, GetDetailRemoteDataSource, DetailTransformer>>>
    
    var body: some View {
        ZStack {
            if presenter.isLoading {
                ProgressView("loadingDetail".localized(identifier: "com.Ikhsan.TheMovieApp"))
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
            } else if let error = presenter.error {
                VStack {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                    Button("retry".localized(identifier: "com.Ikhsan.TheMovieApp")) {
                        presenter.getMovieDetail()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()
            } else if let movie = presenter.movie {
                MovieDetailContentView(movie: movie)
                    .padding()
            }
        }
        .navigationTitle(presenter.movie?.title ?? "detailTitle".localized(identifier: "com.Ikhsan.TheMovieApp"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    presenter.toggleFavoriteStatus()
                }) {
                    Image(systemName: presenter.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                }
            }
        }
        .onAppear {
            presenter.getMovieDetail()
        }
    }
}
