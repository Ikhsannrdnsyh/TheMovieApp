//
//  PopularView.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 31/12/24.
//

import SwiftUI
import Core
import Category
import Common

struct PopularView: View {
    @ObservedObject var presenter: GetListPresenter<MovieCategoryType, CategoryDomainModel,
                                                    Interactor<MovieCategoryType, [CategoryDomainModel],
                                                               GetCategoriesRepository<GetCategoriesLocaleDataSource,
                                                                                       GetCategoriesRemoteDataSource,
                                                                                       CategoryTransformer>>>
    private let router = HomeRouter(persistentContainer: CoreDataManager.shared.persistentContainer)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("popularTitle".localized(identifier: "com.Ikhsan.TheMovieApp"))
                .font(.title)
                .fontWeight(.semibold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    if presenter.isLoadingPopular {
                        ProgressView("loadingTitlePopular".localized(identifier: "com.Ikhsan.TheMovieApp"))
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    } else {
                        let uniqueMovies = removeDuplicates(from: presenter.popularMovies)
                        if uniqueMovies.isEmpty {
                            Text("noMovie".localized(identifier: "com.Ikhsan.TheMovieApp"))
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            ForEach(uniqueMovies, id: \.id) { movie in
                                if let categoryType = MovieCategoryType(rawValue: movie.category ?? "") {
                                    NavigationLink(destination: router.makeDetailView(for: movie, category: categoryType)) {
                                        PopularMovieRow(movies: movie)
                                            .padding(8)
                                    }
                                } else {
                                    Text("inValid".localized(identifier: "com.Ikhsan.TheMovieApp"))
                                        .foregroundColor(.red)
                                }

                                
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            if let error = presenter.popularError {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .padding()
            }
        }
    }

    private func removeDuplicates(from movies: [CategoryDomainModel]) -> [CategoryDomainModel] {
        var seen = Set<Int32>()
        return movies.reduce(into: [CategoryDomainModel]()) { result, movie in
            if !seen.contains(movie.id) {
                seen.insert(movie.id)
                result.append(movie)
            }
        }
    }
}
