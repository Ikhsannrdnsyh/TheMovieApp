//
//  String+Localization.swift
//  Common
//
//  Created by Mochamad Ikhsan Nurdiansyah on 29/03/25.
//

import Foundation

extension String {
  public func localized(identifier: String) -> String {
    let bundle = Bundle(identifier: identifier) ?? .main
    return bundle.localizedString(forKey: self, value: nil, table: nil)
  }
}
