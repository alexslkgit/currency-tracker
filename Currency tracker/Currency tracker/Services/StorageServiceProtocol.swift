//
//  StorageServiceProtocol.swift
//  Currency tracker
//
//  Created by Slobodianiuk Oleksandr on 21.04.2025.
//

import Foundation

protocol StorageServiceProtocol {
    func saveSelectedAssets(_ assets: [Asset])
    func getSelectedAssets() -> [Asset]
}

final class StorageService: StorageServiceProtocol {
    private enum Constants {
        static let selectedAssetsKey = "selectedAssets"
    }
    
    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    func saveSelectedAssets(_ assets: [Asset]) {
        guard let data = try? encoder.encode(assets) else { return }
        defaults.set(data, forKey: Constants.selectedAssetsKey)
    }
    
    func getSelectedAssets() -> [Asset] {
        guard
            let data = defaults.data(forKey: Constants.selectedAssetsKey),
            let assets = try? decoder.decode([Asset].self, from: data)
        else {
            return defaultAssets()
        }
        return assets
    }
    
    private func defaultAssets() -> [Asset] {
        [
            .init(symbol: "USD", name: "US Dollar", category: .fiat),
            .init(symbol: "EUR", name: "Euro",     category: .fiat),
            .init(symbol: "BTC", name: "Bitcoin",  category: .crypto)
        ]
    }
}
