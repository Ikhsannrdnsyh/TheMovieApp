//
//  ImageUrlHelper.swift
//  Core
//
//  Created by Mochamad Ikhsan Nurdiansyah on 16/03/25.
//

import Foundation

public struct ImageUrlHelper {
    public static func buildImageUrl(from path: String?, baseUrl: String) -> String? {
        guard let path = path, !path.isEmpty else { return nil }
        return "\(baseUrl)\(path)"
    }
    
    public static func buildPosterUrl(from path: String?) -> String? {
        return buildImageUrl(from: path, baseUrl: APIConstants.basePosterUrl)
    }
    
    public static func buildBackdropUrl(from path: String?) -> String? {
        return buildImageUrl(from: path, baseUrl: APIConstants.baseBackdropUrl)
    }
}
