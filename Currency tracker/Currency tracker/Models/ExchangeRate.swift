//
//  ExchangeRate.swift
//  Currency tracker
//
//  Created by Slobodianiuk Oleksandr on 21.04.2025.
//

import Foundation

struct ExchangeRate: Codable {
    
    private enum Constants {
        static let identityRate: Double = 1.0
    }
    
    // MARK: - Properties
    
    let base: String
    let date: Date
    let rates: [String: Double]
    
    // MARK: - API
    
    func rate(for symbol: String) -> Double? {
        symbol == base ? Constants.identityRate : rates[symbol]
    }
}
