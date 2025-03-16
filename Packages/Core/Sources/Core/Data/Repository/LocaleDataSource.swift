//
//  LocaleDataSource.swift
//  Core
//
//  Created by Mochamad Ikhsan Nurdiansyah on 16/03/25.
//

import Combine
 
public protocol LocaleDataSource {
    associatedtype Request
    associatedtype Response
 
    func getMovies(request: Request) -> AnyPublisher<[Response], Error>
    func addMovies(entities: [Response]) -> AnyPublisher<Bool, Error>
    func getMovieDetail(id: Int) -> AnyPublisher<Response, Error>
    
}
