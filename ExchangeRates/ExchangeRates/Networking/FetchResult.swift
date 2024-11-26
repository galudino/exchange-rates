//
//  FetchResult.swift
//  ExchangeRates
//
//  Created by Gemuele Aludino on 11/25/24.
//

import Foundation

struct ExchangeRate: Codable, Identifiable, Hashable {
    var id: ObjectIdentifier {
        ObjectIdentifier(NSUUID())
    }
    
    let symbol: String
    let rate: Double
}

struct FetchResult: Codable {
    enum CodingKeys: String, CodingKey {
        case baseCurrency = "base"
        case startDateString = "start_date"
        case endDateString = "end_date"
        case exchangeRates = "rates"
    }
    
    let baseCurrency: String
    let startDateString = "start_date"
    let endDateString = "end_date"
    let exchangeRates: [String: Double]

    func startDate(formatter: DateFormatter = Self.defaultDateFormatter) -> Date {
        formatter.date(from: startDateString)!
    }
    
    func endDate(formatter: DateFormatter = Self.defaultDateFormatter) -> Date {
        formatter.date(from: endDateString)!
    }
    
    static var defaultDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/DD"
        return formatter
    }
}
