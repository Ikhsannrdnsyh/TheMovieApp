//
//  CustomeError+Ext.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 26/12/24.
//

import Foundation

enum URLError: LocalizedError {
    
    case invalidResponse
    case addressUnreachable(URL)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse: return "The server responded with garbage."
        case .addressUnreachable(let url): return "\(url.absoluteString) is unreachable."
        }
    }
    
}

enum DatabaseError: LocalizedError {
    case invalidInstance
    case requestFailed
    case initializationFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidInstance: return "Database can't instance."
        case .requestFailed: return "Your request failed."
        case .initializationFailed: return "Error Initialization"
        }
    }
    
}
