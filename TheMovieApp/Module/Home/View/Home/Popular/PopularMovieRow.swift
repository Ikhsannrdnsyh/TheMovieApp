//
//  PopularMovieRow.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 29/12/24.
//

import SwiftUI
import CachedAsyncImage

private let width: CGFloat = 270
private let height: CGFloat = 180

struct PopularMovieRow: View {
    let movies: MovieModel
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                VStack(spacing: 4) {
                    VStack(spacing: 12){
                        if let backdropPath = movies.backdropPath, let url = URL(string: backdropPath) {
                            CachedImageView(url: url)
                        } else {
                            placeholder
                        }
                        content(for: movies)
                    }
                    .frame(width: width, height: height)
                }
            }
        }
    }
    
    private func content(for movie: MovieModel) -> some View {
        Text(movie.title)
            .font(.caption)
            .lineLimit(2)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 4)
    }
    
    private var placeholder: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.4))
            .frame(width: width, height: height - 20)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct CachedImageView: View {
    let url: URL
    
    var body: some View {
        CachedAsyncImage(url: url) { image in
            switch image {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height - 20 )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            case .failure:
                placeholder
            case .empty:
                ProgressView()
                    .frame(width: width, height: height - 20)
            @unknown default:
                placeholder
            }
        }
    }
    
    private var placeholder: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.4))
            .frame(width: width, height: height - 20)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
