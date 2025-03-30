//
//  MovieDetailContentView.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 30/12/24.
//

import SwiftUI
import CachedAsyncImage
import Category
import Common

struct MovieDetailContentView: View {
    let movie: CategoryDomainModel
    
    var body: some View {
        List {
            backdropImage
            movieDetails
        }
    }
}

extension MovieDetailContentView {
    private var backdropImage: some View {
        Group {
            if let backdropPath = movie.backdropPath, !backdropPath.isEmpty, let imageURL = URL(string: backdropPath) {
                CachedAsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(16 / 9, contentMode: .fill)
                            .frame(maxWidth: .infinity)
                    case .failure, .empty:
                        placeholderView
                    @unknown default:
                        placeholderView
                    }
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            } else {
                placeholderView
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
        }
    }

    private var movieDetails: some View {
        VStack(alignment: .leading, spacing: 8) {
            genreRow
            releaseRow
            durationRow
            descriptionRow
            ratingRow
        }
    }
    
    private var genreRow: some View {
        HStack {
            Text("Genre          : ")
            Text(movie.genres?.map { $0.name }.joined(separator: ", ") ?? "Unknown Genre")
        }
    }
    
    private var releaseRow: some View {
        HStack {
            Text("releasedList".localized(identifier: "com.Ikhsan.TheMovieApp"))
            Text("\(movie.yearText)")
        }
    }
    
    private var durationRow: some View {
        HStack {
            Text("durationList".localized(identifier: "com.Ikhsan.TheMovieApp"))
            Text("\(movie.durationText)")
        }
    }
    
    private var descriptionRow: some View {
        VStack(alignment: .leading){
            Text("descList".localized(identifier: "com.Ikhsan.TheMovieApp"))
            Text(movie.overview)
        }
    }
    
    private var ratingRow: some View {
        HStack {
            if !movie.ratingText.isEmpty {
                Text(movie.ratingText).foregroundColor(.yellow)
            }
            Text(movie.scoreText)
        }
    }
    
    private var placeholderView: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .aspectRatio(16 / 9, contentMode: .fit)
            Text("noImageAvail".localized(identifier: "com.Ikhsan.TheMovieApp"))
                .foregroundColor(.white)
                .font(.headline)
        }
    }
}
