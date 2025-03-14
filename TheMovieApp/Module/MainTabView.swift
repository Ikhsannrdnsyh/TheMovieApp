//
//  MainTabView.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 31/12/24.
//

import SwiftUI

struct MainTabView: View {
    @ObservedObject var homePresenter: HomePresenter
    @ObservedObject var searchPresenter: SearchPresenter
    @ObservedObject var favoritePresenter: FavoritePresenter
    
    init(homePresenter: HomePresenter, searchPresenter: SearchPresenter, favoritePresenter: FavoritePresenter) {
        _homePresenter = ObservedObject(wrappedValue: homePresenter)
        _searchPresenter = ObservedObject(wrappedValue: searchPresenter)
        _favoritePresenter = ObservedObject(wrappedValue: favoritePresenter)
    }
    
    var body: some View {
        TabView {
            NavigationStack {
                HomeView(presenter: homePresenter)
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            
            NavigationStack {
                SearchView(presenter: searchPresenter)
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            
            NavigationStack {
                FavoriteView(presenter: favoritePresenter)
            }
            .tabItem {
                Label("Favorite", systemImage: "heart.circle.fill")
            }
            
            NavigationStack{
                AboutView()
            }
            .tabItem {
                Label("About", systemImage: "person.circle")
            }
        }
    }
}
