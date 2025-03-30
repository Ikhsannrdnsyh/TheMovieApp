//
//  HomeRouter.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 29/12/24.
//

import SwiftUI
import CoreData
import Category

class HomeRouter {
    private let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    @MainActor
    func makeDetailView(for movie: CategoryDomainModel, category: MovieCategoryType) -> some View {
        let presenter = Injection().provideDetailMovie(movieId: movie.id ,categoryType:category)
            return DetailView(presenter: presenter)
        }
}






