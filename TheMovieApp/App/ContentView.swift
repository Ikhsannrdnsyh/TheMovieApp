//
//  ContentView.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 24/12/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var homePresenter: HomePresenter
    @EnvironmentObject var searchPresenter: SearchPresenter
    @EnvironmentObject var favoritePresenter: FavoritePresenter
    
    var body: some View {
        NavigationStack {
            MainTabView(homePresenter: homePresenter, searchPresenter: searchPresenter, favoritePresenter: favoritePresenter)
        }
    }
}
