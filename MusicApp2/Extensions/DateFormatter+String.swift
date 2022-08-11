//
//  DateFormatter.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 4.07.22.
//

import Foundation

extension DateFormatter {
    static var dateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter
    }()
    
    static var displayDateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
}
extension String {
    static func formattedDate(string: String) -> String {
        guard let date = DateFormatter.dateFormatter.date(from: string) else {
            return string
        }
        return DateFormatter.displayDateFormatter.string(from: date)
    }
}
