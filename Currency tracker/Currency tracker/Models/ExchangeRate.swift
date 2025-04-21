//
//  ExchangeRate.swift
//  Currency tracker
//
//  Created by Slobodianiuk Oleksandr on 21.04.2025.
//

import Foundation

struct ExchangeRate: Codable {
    let base: String
    let date: Date
    let rates: [String: Double]
    
    func rate(for symbol: String) -> Double? {
        if symbol == base {
            return 1.0
        }
        return rates[symbol]
    }
}
