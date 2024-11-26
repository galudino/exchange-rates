//
//  Truncatable.swift
//  ExchangeRates
//
//  Created by Gemuele Aludino on 11/25/24.
//

protocol Truncatable: FloatingPoint {
    var truncated: String { get }
}
