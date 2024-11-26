//
//  ExchangeRatesApp.swift
//  ExchangeRates
//
//  Created by Gemuele Aludino on 11/23/24.
//

import SwiftUI

@main struct ExchangeRatesApp: App {

    // MARK: Lifecycle

    init() {
        modelData = ModelData(networkService: NetworkService())
    }

    // MARK: Internal

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(modelData)
        }
    }

    // MARK: Private

    @State private var modelData: ModelData
}
