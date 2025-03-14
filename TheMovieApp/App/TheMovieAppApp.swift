//
//  TheMovieAppApp.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 24/12/24.
//

import SwiftUI
import CoreData

@main
struct TheMovieAppApp: App {
    @StateObject private var homePresenter: HomePresenter
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
        let homeRouter = HomeRouter(persistentContainer: persistentContainer)
        let searchRouter = SearchRouter(persistentContainer: persistentContainer)
        
        let favoriteRouter = FavoriteRouter(persistentContainer: persistentContainer)
        
        let homeUseCase = Injection().provideHome(persistentContainer: persistentContainer)
        let searchUseCase = Injection().provideSearch(persistentContainer: persistentContainer)
        
        let favoriteUseCase = Injection().provideFavorite(persistenContainer: persistentContainer)
        
        _homePresenter = StateObject(wrappedValue: HomePresenter(homeUseCase: homeUseCase, router: homeRouter))
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
