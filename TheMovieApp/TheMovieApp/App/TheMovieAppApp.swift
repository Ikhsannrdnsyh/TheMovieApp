//
//  TheMovieAppApp.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 24/12/24.
//

import SwiftUI
import CoreData
import Core
import Category
import Favorites
import Search

@main
struct TheMovieAppApp: App {
    @StateObject private var homePresenter: GetListPresenter<
        MovieCategoryType, CategoryDomainModel,
        Interactor<MovieCategoryType, [CategoryDomainModel],
                   GetCategoriesRepository<GetCategoriesLocaleDataSource,
                                           GetCategoriesRemoteDataSource,
                                           CategoryTransformer>>
    >
    
    @StateObject private var searchPresenter: GetSearchPresenter<
        String,
        [CategoryDomainModel],
        Interactor<String, [CategoryDomainModel], GetSearchRepository<GetSearchLocaleDataSource, GetSearchRemoteDataSource, CategoryTransformer>>
    >
    
    @StateObject private var favoritePresenter: GetFavoritePresenter<
        Int,
        [CategoryDomainModel],
        Interactor<Int, [CategoryDomainModel], GetFavoritesRepository<GetFavoriteLocaleDataSource, GetFavoriteRemoteDataSource>>
    >
    
    private let persistentContainer = CoreDataManager.shared.persistentContainer
    
    init() {
        
        let injection = Injection()
        
        let homeUseCase = injection.provideCategory(persistentContainer: persistentContainer) ??
        Interactor(repository: GetCategoriesRepository(
            localeDataSource: GetCategoriesLocaleDataSource(context: persistentContainer.viewContext),
            remoteDataSource: GetCategoriesRemoteDataSource(),
            mapper: CategoryTransformer(context: persistentContainer.viewContext)
        ))
        
        
        
        _homePresenter = StateObject(wrappedValue: GetListPresenter(useCase: homeUseCase))
        _searchPresenter = StateObject(wrappedValue: injection.provideSearchMovies())
        _favoritePresenter = StateObject(wrappedValue: injection.provideFavoriteMovies())
        
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(homePresenter)
                .environmentObject(searchPresenter)
                .environmentObject(favoritePresenter)
        }
    }
}
