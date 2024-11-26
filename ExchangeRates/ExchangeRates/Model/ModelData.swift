//
//  ModelData.swift
//  ExchangeRates
//
//  Created by Gemuele Aludino on 11/26/24.
//

import Foundation
import Observation

// MARK: - ModelData

@Observable class ModelData {

    // MARK: Lifecycle

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    // MARK: Internal

    enum State {
        case notApplicable
        case fetchedCurrencies
        case fetchedResult
        case failed(error: Error)
    }

    private(set) var currencies: [String: String] = [:]
    private(set) var exchangeRates: [String: Double] = [:]

    private(set) var state: State = .notApplicable

    func fetchCurrencies() async throws {
        currencies = try await networkService.fetchCurrencyDictionary()
        state = .fetchedCurrencies
    }

    func fetchExchangeRates(date: Date, baseCurrency: String) async throws {
        let result = try await networkService
            .fetchRatesForSingleDate(date, baseCurrency: baseCurrency)
        exchangeRates = result.exchangeRates
        state = .fetchedResult
    }

    func fetchExchangeRates(startDate: Date, endDate: Date, baseCurrency: String) async throws {
        let result = try await networkService
            .fetchRatesForDateInterval(startDate: startDate, endDate: endDate, baseCurrency: baseCurrency)
        exchangeRates = result.exchangeRates
        state = .fetchedResult
    }

    // MARK: Private

    private var networkService: NetworkService
}
