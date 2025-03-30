//
//  SearchRouter.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 31/12/24.
//

import SwiftUI
import CoreData
import Category

class SearchRouter {
    
    @MainActor func makeDetailView(for movie: CategoryDomainModel, category: MovieCategoryType) -> some View {
        let presenter = Injection().provideDetailMovie(movieId: movie.id, categoryType: category)
        return DetailView(presenter: presenter)
    }
}
