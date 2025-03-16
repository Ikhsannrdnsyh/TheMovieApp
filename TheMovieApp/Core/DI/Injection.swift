//
//  Injection.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 29/12/24.
//

import Foundation
import CoreData
import Core
import Category

final class Injection: NSObject {
    
    private func provideRepository(persistentContainer: NSPersistentContainer) -> MovieRepositoryProtocol {
        let locale: LocaleDataSource = LocaleDataSource.sharedInstance(persistentContainer)
        let remote: RemoteDataSource = RemoteDataSource.sharedInstance
        return MoviesRepository.sharedInstance(locale, remote)
    }
    
    func provideHome(persistentContainer: NSPersistentContainer) -> HomeUseCase {
        let repository = provideRepository(persistentContainer: persistentContainer)
        return HomeInteractor(repository: repository)
    }
    
    func provideDetail(movie: MovieModel, persistentContainer: NSPersistentContainer) -> DetailUseCase {
        let repository = provideRepository(persistentContainer: persistentContainer)
        return DetailInteractor(repository: repository, movie: movie)
    }
    
    func provideSearch(persistentContainer: NSPersistentContainer) -> SearchUseCase {
        let repository = provideRepository(persistentContainer: persistentContainer)
        return SearchInteractor(repository: repository)
    }
    
    func provideFavorite(persistenContainer: NSPersistentContainer) -> FavoriteUseCase {
        let repository = provideRepository(persistentContainer: persistenContainer)
        return FavoriteInteractor(repository: repository)
    }
    
    @MainActor
    func provideCategory<U: UseCase>(persistentContainer: NSPersistentContainer) -> U where U.Request == MovieCategoryType, U.Response == [CategoryDomainModel] {
        let locale = GetCategoriesLocaleDataSource(context: persistentContainer.viewContext)
        let remote = GetCategoriesRemoteDataSource()
        let mapper = CategoryTransformer(context: persistentContainer.viewContext)
        
        let repository = GetCategoriesRepository(
            localeDataSource: locale,
            remoteDataSource: remote,
            mapper: mapper
        )
        
        return Interactor(repository: repository) as! U
    }
}
