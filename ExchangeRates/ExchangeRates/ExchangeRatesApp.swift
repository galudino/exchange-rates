//
//  ExchangeRatesApp.swift
//  ExchangeRates
//
//  Created by Gemuele Aludino on 11/23/24.
//

import SwiftUI

@main
struct ExchangeRatesApp: App {
    @State private var modelData: ModelData
    
    init() {
        modelData = ModelData(networkService: NetworkService())
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(modelData)
        }
    }
}
