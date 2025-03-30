//
//  GetSearchPresenter.swift
//  Search
//
//  Created by Mochamad Ikhsan Nurdiansyah on 26/03/25.
//

import Combine
import SwiftUI
import Core
import Category


@MainActor
public class GetSearchPresenter<Request, Response, Interactor: UseCase>: ObservableObject
where Interactor.Request == Request, Interactor.Response == Response {
    
    private let _useCase: Interactor
    private var cancellables: Set<AnyCancellable> = []
    
    @Published public var query: String = ""
    @Published public var searchResults: Response? = nil
    @Published public var isLoading: Bool = false
    @Published public var error: String?
    @Published public var movies: [CategoryDomainModel] = []
    
    public init(useCase: Interactor) {
        self._useCase = useCase
        setupSearchListener()
    }
    
    public func setupSearchListener() {
        $query
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] newQuery in
                guard let self = self else { return }
                if newQuery.isEmpty {
                    self.searchResults = nil
                } else {
                    self.executeSearch(query: newQuery)
                }
            }
            .store(in: &cancellables)
    }
    
    public func executeSearch(query: String) {
        isLoading = true
        error = nil
        print("🔍 Searching for query: \(query)")

        _useCase.execute(request: query as? Request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.error = error.localizedDescription
                    print("❌ Search failed: \(error.localizedDescription)")
                case .finished:
                    print("✅ Search completed")
                }
            }, receiveValue: { results in
                print("🎬 Received results: \(results)") // Debug output

                self.searchResults = results

                if let movies = results as? [CategoryDomainModel] {
                    self.movies = movies
                    print("🎥 Movies list updated: \(movies)")
                }
            })
            .store(in: &cancellables)
    }

}
