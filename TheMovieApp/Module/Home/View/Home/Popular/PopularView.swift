//
//  PopularView.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 31/12/24.
//

import SwiftUI

struct PopularView: View {
    @ObservedObject var presenter: HomePresenter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Popular")
                .font(.title)
                .fontWeight(.semibold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    if presenter.isLoadingPopular {
                        ProgressView("Loading Popular Movies...")
                    } else if !presenter.popularMovies.isEmpty {
                        ForEach(self.presenter.popularMovies, id: \.id) { movie in
                            ZStack {
                                presenter.linkBuilder(for: movie) {
                                    PopularMovieRow(movies: movie)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(8)
                        }
                    } else if let error = presenter.popularError {
                        Text("Error: \(error)")
                            .foregroundStyle(Color.red)
                    }
                }
            }
        }
    }
}
