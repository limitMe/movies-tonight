//
//  String+l10n.swift
//  MoviesTonight
//
//  Created by Dian Zhong on 20/08/2017.
//
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
