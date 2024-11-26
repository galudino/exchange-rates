//
//  Date+Extensions.swift
//  ExchangeRates
//
//  Created by Gemuele Aludino on 11/25/24.
//

import Foundation

extension Date {
    static var dateFormatterForYYYYMMDD: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }

    static func dateFromString(_ dateString: String,
                               formatter: DateFormatter = Self.dateFormatterForYYYYMMDD) {
        formatter.date(from: dateString)
    }
}
