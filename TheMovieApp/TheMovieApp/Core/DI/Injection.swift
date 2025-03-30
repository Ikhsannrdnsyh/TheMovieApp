//
//  Injection.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 29/12/24.
//

import Foundation
import CoreData
import Category
import Core
import Detail
import Favorites
import Search

final class Injection: NSObject {
    
    @MainActor
    func provideCategory(persistentContainer: NSPersistentContainer) ->
    Interactor<MovieCategoryType, [CategoryDomainModel],
               GetCategoriesRepository<GetCategoriesLocaleDataSource,
                                       GetCategoriesRemoteDataSource, CategoryTransformer>>? {
                                           
                                           let locale = GetCategoriesLocaleDataSource(context: persistentContainer.viewContext)
                                           let remote = GetCategoriesRemoteDataSource()
                                           let mapper = CategoryTransformer(context: persistentContainer.viewContext)
                                           
                                           let repository = GetCategoriesRepository(localeDataSource: locale, remoteDataSource: remote, mapper: mapper)
                                           
                                           return Interactor(repository: repository)
                                       }
    
    @MainActor
    func provideDetailMovie(movieId: CategoryDomainModel.ID, categoryType: MovieCategoryType) -> GetDetailPresenter<
        Int,
        CategoryDomainModel,
        Interactor<Int, CategoryDomainModel, GetDetailRepository<GetDetailLocaleDataSource, GetDetailRemoteDataSource, DetailTransformer>>
    > {
        
        let context = CoreDataManager.shared.context
        let localeDataSource = GetDetailLocaleDataSource(context: context)
        let remoteDataSource = GetDetailRemoteDataSource()
        let mapper = DetailTransformer(context: context)
        
        let repository = GetDetailRepository<GetDetailLocaleDataSource, GetDetailRemoteDataSource, DetailTransformer>(
            localeDataSource: localeDataSource,
            remoteDataSource: remoteDataSource,
            mapper: mapper,
            categoryType: categoryType
        )
        
        let interactor = Interactor(repository: repository)
        
        let favoriteLocaleDataSource = GetFavoriteLocaleDataSource()
        let favoriteRemoteDataSource = GetFavoriteRemoteDataSource()
        let favoriteTransformer = FavoriteTransformer()

        let favoriteRepository = GetFavoritesRepository<GetFavoriteLocaleDataSource, GetFavoriteRemoteDataSource>(
            localDataSource: favoriteLocaleDataSource,
            remoteDataSource: favoriteRemoteDataSource,
            transformer: favoriteTransformer
        )

        return GetDetailPresenter(
            movieId: Int(movieId),
            useCase: interactor,
            favoriteRepository: favoriteRepository
        )
    }

    
    @MainActor
    func provideFavoriteMovies() -> GetFavoritePresenter<
        Int,
        [CategoryDomainModel],
        Interactor<Int, [CategoryDomainModel], GetFavoritesRepository<GetFavoriteLocaleDataSource, GetFavoriteRemoteDataSource>>
    > {
        
        let context = CoreDataManager.shared.context
        let localeDataSource = GetFavoriteLocaleDataSource(context: context)
        let remoteDataSource = GetFavoriteRemoteDataSource()
        let mapper = FavoriteTransformer()
        
        let repository = GetFavoritesRepository<GetFavoriteLocaleDataSource, GetFavoriteRemoteDataSource>(
            localDataSource: localeDataSource, remoteDataSource: remoteDataSource,
            transformer: mapper
        )
        
        let interactor = Interactor(repository: repository)
        
        return GetFavoritePresenter(useCase: interactor)
    }
    
    @MainActor
    func provideSearchMovies() -> GetSearchPresenter<
        String,
        [CategoryDomainModel],
        Interactor<String, [CategoryDomainModel], GetSearchRepository<GetSearchLocaleDataSource, GetSearchRemoteDataSource, CategoryTransformer>>
    > {
        
        let context = CoreDataManager.shared.context
        let localeDataSource = GetSearchLocaleDataSource(context: context)
        let remoteDataSource = GetSearchRemoteDataSource()
        let mapper = CategoryTransformer(context: context)

        let repository = GetSearchRepository<GetSearchLocaleDataSource, GetSearchRemoteDataSource, CategoryTransformer>(
            localeDataSource: localeDataSource,
            remoteDataSource: remoteDataSource,
            mapper: mapper
        )

        let interactor = Interactor(repository: repository)

        return GetSearchPresenter(useCase: interactor)
    }

}
