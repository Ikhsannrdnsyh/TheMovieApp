//
//  ImageUrlHelper.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 29/12/24.
//

import Foundation

struct ImageUrlHelper {
    static func buildPosterUrl(from path: String?) -> String? {
        guard let path = path else { return nil }
        return "\(API.basePosterUrl)\(path)"
    }
    
    static func buildBackdropUrl(from path: String?) -> String? {
        guard let path = path else { return nil }
        return "\(API.baseBackdropUrl)\(path)"
    }
}
