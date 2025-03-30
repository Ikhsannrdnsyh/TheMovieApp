//
//  MainTabView.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 31/12/24.
//

import SwiftUI
import Core
import Category
import Favorites
import Search

struct MainTabView: View {
    @ObservedObject var homePresenter: GetListPresenter<MovieCategoryType, CategoryDomainModel,
                                                        Interactor<MovieCategoryType, [CategoryDomainModel],
                                                                   GetCategoriesRepository<GetCategoriesLocaleDataSource,
                                                                                           GetCategoriesRemoteDataSource,
                                                                                           CategoryTransformer>>>
    @ObservedObject var searchPresenter: GetSearchPresenter<String, [CategoryDomainModel],
                                                            Interactor<String, [CategoryDomainModel],
                                                                       GetSearchRepository<GetSearchLocaleDataSource,
                                                                                           GetSearchRemoteDataSource,
                                                                                           CategoryTransformer>>>
    @ObservedObject var favoritePresenter: GetFavoritePresenter<Int,
                                                                [CategoryDomainModel],
                                                                Interactor<
                                                                    Int,
                                                                    [CategoryDomainModel],
                                                                    GetFavoritesRepository<GetFavoriteLocaleDataSource, GetFavoriteRemoteDataSource>
                                                                >
    >
    
    var body: some View {
        TabView {
            HomeView(presenter: homePresenter)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            SearchView(presenter: searchPresenter)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            FavoriteView(presenter: favoritePresenter)
                .tabItem {
                    Label("Favorite", systemImage: "heart.circle.fill")
                }
            
            AboutView()
                .tabItem {
                    Label("About", systemImage: "person.circle")
                }
        }
    }
}
