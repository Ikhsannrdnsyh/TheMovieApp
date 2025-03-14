//
//  HomeRouter.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 29/12/24.
//

import SwiftUI
import CoreData

class HomeRouter {
    private let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    func makeDetailView(for movie: MovieModel) -> some View {
        let detailUseCase = Injection().provideDetail(movie: movie, persistentContainer: persistentContainer)
        let presenter = DetailPresenter(movieId: Int(movie.id), movieDetailUseCase: detailUseCase)
        
        return DetailView(presenter: presenter)
    }
}






