//
//  HomeView.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 29/12/24.
//

import SwiftUI
import Core
import Category
import Common

struct HomeView: View {
    @ObservedObject var presenter: GetListPresenter<MovieCategoryType, CategoryDomainModel,
                                                    Interactor<MovieCategoryType, [CategoryDomainModel],
                                                               GetCategoriesRepository<GetCategoriesLocaleDataSource,
                                                                                       GetCategoriesRemoteDataSource,
                                                                                       CategoryTransformer>>>
    
    init(presenter: GetListPresenter<MovieCategoryType, CategoryDomainModel,
         Interactor<MovieCategoryType, [CategoryDomainModel],
         GetCategoriesRepository<GetCategoriesLocaleDataSource,
         GetCategoriesRemoteDataSource,
         CategoryTransformer>>>) {
        _presenter = ObservedObject(wrappedValue: presenter)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    NowPlayingView(presenter: presenter)
                    PopularView(presenter: presenter)
                }
                .padding(.horizontal)
            }
            
            .navigationTitle("titleHome".localized(identifier: "com.Ikhsan.TheMovieApp"))
            .navigationBarTitleDisplayMode(.large)
            
            .onAppear {
                presenter.getNowPlayingMovies()
                presenter.getPopularMovies()
            }
            
            .refreshable {
                presenter.getNowPlayingMovies()
                presenter.getPopularMovies()
            }
        }
    }
}
