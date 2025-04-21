//
//  AssetCategory.swift
//  Currency tracker
//
//  Created by Slobodianiuk Oleksandr on 21.04.2025.
//

import Foundation
import SwiftUICore

enum AssetCategory: String, Codable {
    case fiat   = "FIAT"
    case crypto = "CRYPTO"
    case other  = "OTHER"
}

struct Asset: Identifiable, Codable, Hashable {
    
    let symbol: String
    let name: String
    let category: AssetCategory
    var id: String { symbol }
}

extension AssetCategory {
    var color: Color {
        switch self {
        case .fiat:   return .blue
        case .crypto: return .orange
        case .other:  return .purple
        }
    }
}

extension Asset {
    static let defaultList: [Asset] = [
        .init(symbol: "USD", name: "US Dollar",    category: .fiat),
        .init(symbol: "EUR", name: "Euro",         category: .fiat),
        .init(symbol: "GBP", name: "British Pound",category: .fiat),
        .init(symbol: "JPY", name: "Japanese Yen", category: .fiat),
        .init(symbol: "BTC", name: "Bitcoin",      category: .crypto),
        .init(symbol: "ETH", name: "Ethereum",     category: .crypto),
        .init(symbol: "CHF", name: "Swiss Franc",  category: .fiat),
        .init(symbol: "AUD", name: "Australian Dollar", category: .fiat),
        .init(symbol: "USDT",name: "Tether",       category: .crypto),
        .init(symbol: "BNB", name: "Binance Coin", category: .crypto),
        .init(symbol: "XRP", name: "Ripple",       category: .crypto)
    ]
}
