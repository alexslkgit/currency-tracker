//
//  AssetCategory.swift
//  Currency tracker
//
//  Created by Slobodianiuk Oleksandr on 21.04.2025.
//

import Foundation

enum AssetCategory: String, Codable {
    case fiat = "FIAT"
    case crypto = "CRYPTO"
    case other = "OTHER"
}

struct Asset: Identifiable, Hashable, Codable {
    var id: String { symbol }
    let symbol: String
    let name: String
    let category: AssetCategory
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(symbol)
    }
    
    static func == (lhs: Asset, rhs: Asset) -> Bool {
        return lhs.symbol == rhs.symbol
    }
}

