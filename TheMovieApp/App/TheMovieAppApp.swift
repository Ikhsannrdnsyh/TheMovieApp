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

@main
struct TheMovieAppApp: App {
    @StateObject private var homePresenter: GetListPresenter<MovieCategoryType, CategoryDomainModel, Interactor<MovieCategoryType, [CategoryDomainModel], GetCategoriesRepository<GetCategoriesLocaleDataSource, GetCategoriesRemoteDataSource, CategoryTransformer>>>
    @StateObject private var searchPresenter: SearchPresenter
    @StateObject private var favoritePresenter: FavoritePresenter
    
    private let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "MovieModel")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        
        let injection = Injection()  // Gunakan satu instance Injection untuk konsistensi
        
        let homeUseCase: Interactor<MovieCategoryType, [CategoryDomainModel], GetCategoriesRepository<GetCategoriesLocaleDataSource, GetCategoriesRemoteDataSource, CategoryTransformer>> =
        injection.provideCategory(persistentContainer: persistentContainer)
        
        let searchUseCase = injection.provideSearch(persistentContainer: persistentContainer)
        let favoriteUseCase = injection.provideFavorite(persistenContainer: persistentContainer)
        
        let homeRouter = HomeRouter(persistentContainer: persistentContainer)
        let searchRouter = SearchRouter(persistentContainer: persistentContainer)
        let favoriteRouter = FavoriteRouter(persistentContainer: persistentContainer)
        
        _homePresenter = StateObject(wrappedValue: GetListPresenter(useCase: homeUseCase))
        _searchPresenter = StateObject(wrappedValue: SearchPresenter(searchUseCase: searchUseCase, router: searchRouter))
        _favoritePresenter = StateObject(wrappedValue: FavoritePresenter(router: favoriteRouter, favoriteUseCase: favoriteUseCase))
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
