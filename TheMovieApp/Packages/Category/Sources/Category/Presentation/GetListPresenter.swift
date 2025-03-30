//
//  GetListPresenter.swift
//  Category
//
//  Created by Mochamad Ikhsan Nurdiansyah on 16/03/25.
//

import SwiftUI
import Combine
import Core

public class GetListPresenter<Request, Response, Interactor: UseCase>: ObservableObject
where Interactor.Request == Request, Interactor.Response == [Response] {
    
    private var cancellables: Set<AnyCancellable> = []
    private let _useCase: Interactor
    
    // Now Playing Movies
    @Published public var nowPlayingMovies: [Response] = []
    @Published public var isLoadingNowPlaying: Bool = false
    @Published public var nowPlayingError: String?
    
    //  Popular Movies
    @Published public var popularMovies: [Response] = []
    @Published public var isLoadingPopular: Bool = false
    @Published public var popularError: String?
    
    public init(useCase: Interactor) {
        _useCase = useCase
    }
    
    public func getNowPlayingMovies() {
        isLoadingNowPlaying = true
        nowPlayingError = nil
        
        guard let request = MovieCategoryType.nowPlaying as? Request else {
            print("⚠️ Error: Gagal mengonversi MovieCategoryType.nowPlaying ke Request")
            return
        }
        print("Debug: Mengirim Request - \(request)") // Debugging
        
        _useCase.execute(request: request)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.nowPlayingError = error.localizedDescription
                    print("Error: \(error.localizedDescription)") // Debugging
                case .finished:
                    break
                }
                self.isLoadingNowPlaying = false
            }, receiveValue: { movies in
                self.nowPlayingMovies = movies
                print("✅ Now Playing Movies Count: \(movies.count)")
                print("🎬 Now Playing Movies: \(movies)")
            })
            .store(in: &cancellables)
    }
    
    public func getPopularMovies() {
        isLoadingPopular = true
        popularError = nil
        
        guard let request = MovieCategoryType.popular as? Request else {
            print("⚠️ Error: Gagal mengonversi MovieCategoryType.nowPlaying ke Request")
            return
        }
        print(" Debug: Mengirim Request - \(request)")
        
        _useCase.execute(request: request)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.popularError = error.localizedDescription
                    print("Error: \(error.localizedDescription)") // Debugging
                case .finished:
                    break
                }
                self.isLoadingPopular = false
            }, receiveValue: { movies in
                self.popularMovies = movies
                print("✅ Popular Movies Count: \(movies.count)")
                print("🎬 Popular Movies: \(movies)")
            })
            .store(in: &cancellables)
    }
    
}
