//
//  FavoriteRouter.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 03/03/25.
//

import SwiftUI
import CoreData
import Category

class FavoriteRouter {
    
    @MainActor
    func makeDetailView(for movie: CategoryDomainModel, category: MovieCategoryType) -> some View {
        let presenter = Injection().provideDetailMovie(movieId: movie.id, categoryType: category)
        return DetailView(presenter: presenter)
    }
}
