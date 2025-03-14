//
//  HomeView.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 29/12/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var presenter: HomePresenter
    
    init(presenter: HomePresenter) {
        _presenter = ObservedObject(wrappedValue: presenter)
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        NowPlayingView(presenter: presenter)
                        PopularView(presenter: presenter)
                    }
                }
                .onAppear {
                    presenter.getMoviesNowPlaying()
                    presenter.getMoviesPopular()
                }
                .navigationBarTitle("MyMovie", displayMode: .large)
            }
        }
    }
}
