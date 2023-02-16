//
//  DateFormatter.swift
//  LearnWords
//
//  Created by sergemi on 15.02.2023.
//

import Foundation

/// Localized date formatter
final class DateFormatter {
    static func get(_ format: String? = nil) -> Foundation.DateFormatter {
        let formatter = Foundation.DateFormatter()

        formatter.dateFormat = format
        
        return formatter
    }
}

