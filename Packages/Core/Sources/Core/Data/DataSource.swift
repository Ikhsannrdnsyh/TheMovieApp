//
//  DataSource.swift
//  Core
//
//  Created by Mochamad Ikhsan Nurdiansyah on 16/03/25.
//

import Combine
 
public protocol DataSource {
    associatedtype Request
    associatedtype Response
    
    func execute(request: Request?) -> AnyPublisher<Response, Error>
}
