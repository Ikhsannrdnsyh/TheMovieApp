//
//  NowPlayingView.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 31/12/24.
//

import SwiftUI

struct NowPlayingView: View {
    @ObservedObject var presenter: HomePresenter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Now Playing")
                .font(.title)
                .fontWeight(.semibold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    if presenter.isLoadingNowPlaying {
                        ProgressView("Loading Now Playing...")
                    } else if !presenter.nowPlayingMovies.isEmpty {
                        ForEach(self.presenter.nowPlayingMovies, id: \.id) { movie in
                            ZStack {
                                presenter.linkBuilder(for: movie) {
                                    NowPlayingMovieRow(movies: movie)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(8)
                        }
                    } else if let error = presenter.nowPlayingError {
                        Text("Error: \(error)")
                            .foregroundStyle(Color.red)
                    }
                }
            }
        }
    }
}
