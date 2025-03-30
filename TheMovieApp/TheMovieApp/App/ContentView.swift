//
//  ContentView.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 24/12/24.
//

import SwiftUI
import Core
import Category
import Favorites
import Search

struct ContentView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @EnvironmentObject var homePresenter: GetListPresenter<MovieCategoryType, CategoryDomainModel,
                                                           Interactor<MovieCategoryType, [CategoryDomainModel],
                                                                      GetCategoriesRepository<GetCategoriesLocaleDataSource,
                                                                                              GetCategoriesRemoteDataSource,
                                                                                              CategoryTransformer>>>
    @EnvironmentObject var searchPresenter: GetSearchPresenter<String, [CategoryDomainModel],
                                                                Interactor<String, [CategoryDomainModel],
                                                                           GetSearchRepository<GetSearchLocaleDataSource,
                                                                                               GetSearchRemoteDataSource,
                                                                                               CategoryTransformer>>>
    @EnvironmentObject var favoritePresenter: GetFavoritePresenter<
        Int,
        [CategoryDomainModel],
        Interactor<
            Int,
            [CategoryDomainModel],
            GetFavoritesRepository<GetFavoriteLocaleDataSource, GetFavoriteRemoteDataSource>>>
    
    var body: some View {
        NavigationStack {
            MainTabView(
                homePresenter: homePresenter,
                searchPresenter: searchPresenter,
                favoritePresenter: favoritePresenter
            )
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}
