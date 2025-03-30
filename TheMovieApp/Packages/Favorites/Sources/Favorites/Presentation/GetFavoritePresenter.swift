//
//  GetFavoritePresenter.swift
//  Favorites
//
//  Created by Mochamad Ikhsan Nurdiansyah on 25/03/25.
//

import Combine
import SwiftUI
import Core
import Category

public class GetFavoritePresenter<Request, Response, Interactor: UseCase>: ObservableObject
where Interactor.Request == Request, Interactor.Response == Response {
    
    private let _useCase: Interactor
    private var cancellables: Set<AnyCancellable> = []
    
    @Published public var movies: Response?
    @Published public var isLoading: Bool = false
    @Published public var error: String?
    
    public init(useCase: Interactor) {
        self._useCase = useCase
    }
    
    public func getFavoriteMovies() {
        isLoading = true
        error = nil
        
        _useCase.execute(request: nil)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.error = error.localizedDescription
                    print("❌ Error mengambil data favorit: \(error.localizedDescription)") // Debugging
                case .finished:
                    break
                }
            }, receiveValue: { movies in
                self.movies = movies
                print("📌 Data favorit ditemukan: \(String(describing: movies))") // Debugging
            })
            .store(in: &cancellables)
    }
    
}
