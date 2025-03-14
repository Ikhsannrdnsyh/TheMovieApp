//
//  NowPlayingMovieRow.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 29/12/24.
//

import SwiftUI
import CachedAsyncImage

private let width: CGFloat = 180
private let height: CGFloat = 270

struct NowPlayingMovieRow: View {
    let movies: MovieModel
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                VStack(spacing: 4) {
                    VStack(spacing: 12) {
                        if let posterPath = movies.posterPath, let url = URL(string: posterPath) {
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
            .frame(width: width, height: height )
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
                    .frame(width: width, height: height - 42)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            case .failure:
                placeholder
            case .empty:
                ProgressView()
                    .frame(width: width, height: height - 42)
            @unknown default:
                placeholder
            }
        }
    }
    
    private var placeholder: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.4))
            .frame(width: width, height: height - 42)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
