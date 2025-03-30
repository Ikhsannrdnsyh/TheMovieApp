//
//  NowPlayingMovieRow.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 29/12/24.
//

import SwiftUI
import CachedAsyncImage
import Category

private let width: CGFloat = 180
private let height: CGFloat = 270

struct NowPlayingMovieRow: View {
    let movies: CategoryDomainModel
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    VStack(spacing: 12) {
                        if let url = movies.posterURL {
                            CachedImageView(url: url)
                        } else {
                            placeholder
                        }
                        content(for: movies)
                    }
                    .frame(width: width, height: height)
                }
                .padding(.horizontal)
            }
        }
    }
    
    private func content(for movie: CategoryDomainModel) -> some View {
        Text(movie.title)
            .font(.caption)
            .lineLimit(2)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 4)
    }
    
    private var placeholder: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.4))
            .frame(width: width, height: height - 42)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct CachedImageView: View {
    let url: URL
    
    var body: some View {
        CachedAsyncImage(url: url) { phase in
            switch phase {
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
