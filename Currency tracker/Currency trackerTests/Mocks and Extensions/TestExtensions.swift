//
//  TestExtensions.swift
//  Currency tracker
//
//  Created by Slobodianiuk Oleksandr on 21.04.2025.
//

@testable import ExchangeRateTracker
extension HomeViewModel {
    func testReload() { reloadSelectedAssets() }
}

extension AddAssetViewModel {
    func testReload() { loadAssets() }
}
