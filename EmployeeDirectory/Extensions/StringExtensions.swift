//
//  StringExtensions.swift
//  EmployeeDirectory
//
//  Created by Arshdeep on 2023-07-14.
//

import Foundation

extension String {
    // The localized string for the key represented in `self`.
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
}
