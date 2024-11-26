//
//  ContentView.swift
//  ExchangeRates
//
//  Created by Gemuele Aludino on 11/23/24.
//

import SwiftUI

// MARK: - ContentView

struct ContentView: View {
    @Environment(ModelData.self) var modelData
    
    @State private var startDate: Date = .now
    @State private var endDate: Date = .now
    @State private var baseCurrency: String = "USD"

    var body: some View {
        VStack {
            switch modelData.state {
            case .notApplicable:
                notApplicableView
            case .fetchedCurrencies:
                fetchingCurrenciesView
            case .fetchedResult:
                exchangeRatesList
            case let .failed(error):
                failedToFetchView(error: error)
            }
        }
        .onAppear {
            Task { @MainActor [modelData] in
                try await modelData.fetchCurrencies()
                try await modelData.fetchExchangeRates(date: startDate, baseCurrency: baseCurrency)
            }
        }
        .refreshable {
            Task { @MainActor [modelData] in
                try await modelData.fetchExchangeRates(date: startDate, baseCurrency: baseCurrency)
            }
        }
    }

    private var notApplicableView: some View {
        VStack {
            Text("Welcome to ExchangeRates")
                .font(.title).bold()
        }
    }
    
    private var loadingView: some View {
        VStack {
            ProgressView()
            Text("Loading...")
                .font(.title).bold()
        }
    }

    private var fetchingCurrenciesView: some View {
        VStack {
            ProgressView()
            Text("Fetching currencies...")
                .font(.title).bold()
        }
    }

    private func failedToFetchView(error: Error) -> some View {
        VStack {
            Text("Failed")
                .font(.title).bold()
            Text("\(error)").font(.caption)
        }
    }

    private var currencyPickerSection: some View {
        Section(content: {
            currencyPicker
                .onChange(of: baseCurrency) {
                    Task { @MainActor [modelData] in
                        try await modelData.fetchExchangeRates(date: startDate, baseCurrency: baseCurrency)
                    }
                }
                .pickerStyle(.wheel)
        }, header: {
            Text("Base currency")
        }, footer: {
            Text("Last refreshed: \(Date.now)")
        })
    }

    private var currencyPicker: some View {
        Picker("Currency", selection: $baseCurrency) {
            ForEach(Array(modelData.currencies.keys.sorted()), id: \.self) { symbol in
                Text("\(modelData.currencies[symbol]!)")
                    .tag(symbol)
            }
        }
    }
    
    private static var minimumDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let date = formatter.date(from: "1999/01/03")!
        return date
    }
    
    private var startDatePicker: some View {
        DatePicker(selection: $startDate, in: Self.minimumDate...Date.now, displayedComponents: [.date]) {
            //Text("Start Date")
            Text("Date")
        }
        .onChange(of: startDate) {
            Task { @MainActor [modelData] in
                try await modelData.fetchExchangeRates(date: startDate, baseCurrency: baseCurrency)
            }
        }
    }
    
    private var endDatePicker: some View {
        DatePicker(selection: $endDate, in: startDate...Date.now, displayedComponents: [.date]) {
            Text("End Date")
        }
        .onChange(of: endDate) {
            Task { @MainActor [modelData] in
                try await modelData.fetchExchangeRates(date: startDate, baseCurrency: baseCurrency)
            }
        }
    }
    
    private var datePickerSection: some View {
         Section {
             startDatePicker
             //endDatePicker
         }
    }

    private var exchangeRatesList: some View {
        List {
            datePickerSection
            currencyPickerSection

            ForEach(modelData.exchangeRates.sorted(by: <), id: \.key) { symbol, rate in
                HStack {
                    Text("[\(symbol)]").bold()
                    Text("\(modelData.currencies[symbol] ?? "-")")
                    Spacer()
                    Text("\(rate)")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(ModelData(networkService: NetworkService()))
}
