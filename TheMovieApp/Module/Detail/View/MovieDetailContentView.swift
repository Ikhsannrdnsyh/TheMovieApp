//
//  MovieDetailContentView.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 30/12/24.
//

import SwiftUI
import CachedAsyncImage

struct MovieDetailContentView: View {
    let movie: MovieModel
    
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
            if let imageURL = URL(string: movie.backdropPath ?? "") {
                CachedAsyncImage(url: imageURL) { image in
                    switch image {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(16 / 9, contentMode: .fill)
                            .frame(maxWidth: .infinity)
                    case .failure, .empty:
                        Rectangle().fill(Color.gray.opacity(0.3))
                            .aspectRatio(16 / 9, contentMode: .fit)
                    @unknown default:
                        Rectangle().fill(Color.gray.opacity(0.3))
                            .aspectRatio(16 / 9, contentMode: .fit)
                    }
                }
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
            Text("Released     : ")
            Text("\(movie.yearText)")
        }
    }
    
    private var durationRow: some View {
        HStack {
            Text("Duration      : ")
            Text("\(movie.durationText)")
        }
    }
    
    private var descriptionRow: some View {
        VStack(alignment: .leading){
            Text("Description : ")
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
}
