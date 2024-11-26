//
//  NetworkService.swift
//  ExchangeRates
//
//  Created by Gemuele Aludino on 11/25/24.
//

import Foundation
import Network
import Observation

@Observable
class NetworkService {
    enum RequestError: Error {
        case failed
        case failedToDecode
        case invalidStatusCode
    }

    func fetchCurrencyDictionary() async throws -> [String: String] {
        try await fetchData(fromURL: Self.requestURLForCurrencies)
    }

    func fetchRatesForSingleDate(_ date: Date,
                                 baseCurrency: String) async throws -> FetchResult {
        let url = makeRequestURLForSingleDate(date, baseCurrency: baseCurrency)
        return try await fetchData(fromURL: url)
    }

    func fetchRatesForDateInterval(startDate: Date,
                                   endDate: Date,
                                   baseCurrency: String) async throws -> FetchResult
    {
        let url = makeRequestURLForDateInterval(
            startDate: startDate,
            endDate: endDate, baseCurrency: baseCurrency
        )
        return try await fetchData(fromURL: url)
    }

    private func fetchData<T: Decodable>(fromURL url: URL) async throws -> T {
        #if DEBUG
            let (taskData, response) = try await URLSession(configuration: .ephemeral).data(
                from: url
            )
        #else
            let (taskData, response) = try await URLSession.shared.data(from: url)
        #endif

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw RequestError.invalidStatusCode
        }

        return try JSONDecoder().decode(T.self, from: taskData)
    }

    private static let baseURL = "https://api.frankfurter.app"
    private static let requestURLForCurrencies = URL(string: "\(baseURL)/currencies")!

    private func makeRequestURLForSingleDate(_ date: Date,
                                             baseCurrency: String) -> URL
    {
        let dateString = Date.dateFormatterForYYYYMMDD.string(from: date)

        let urlString = "\(Self.baseURL)/\(dateString)?base=\(baseCurrency)"
        return URL(string: urlString)!
    }

    private func makeRequestURLForDateInterval(startDate: Date,
                                               endDate: Date,
                                               baseCurrency: String) -> URL
    {
        let startDateString = Date.dateFormatterForYYYYMMDD.string(from: startDate)
        let endDateString = Date.dateFormatterForYYYYMMDD.string(from: endDate)

        let urlString = "\(Self.baseURL)/\(startDateString)..\(endDateString)?base=\(baseCurrency)"
        return URL(string: urlString)!
    }
}
