//
//  HomeViewModelTests.swift
//  Currency tracker
//
//  Created by Slobodianiuk Oleksandr on 21.04.2025.
//

import XCTest
@testable import Currency_tracker

final class HomeViewModelTests: XCTestCase {
    
    private var vm: HomeViewModel!
    private var api: MockAPIService!
    private var store: MockStorageService!
    
    override func setUp() {
        super.setUp()
        api   = MockAPIService()
        store = MockStorageService()
        vm    = HomeViewModel(apiService: api, storageService: store)
    }
    
    override func tearDown() {
        vm = nil; api = nil; store = nil
        super.tearDown()
    }
    
    @MainActor
    func testReloadSelectedAssets() {
        // Given
        store.mockSelectedAssets = [.init(symbol: "USD", name: "US Dollar", category: .fiat)]
        api.mockExchangeRate = ExchangeRate(base: "USD", date: Date(), rates: ["EUR": 0.85])
        let exp = expectation(description: "reload")
        
        // When
        vm.testReload()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            XCTAssertEqual(self.vm.selectedAssets.first?.symbol, "USD")
            XCTAssertFalse(self.vm.currentRates.isEmpty)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
    @MainActor
    func testRemoveAsset() {
        // Given
        vm.testInjectSelectedAssets([
            .init(symbol: "USD", name: "US Dollar", category: .fiat),
            .init(symbol: "EUR", name: "Euro",      category: .fiat)
        ])
        let usd = Asset(symbol: "USD", name: "US Dollar", category: .fiat)
        
        // When
        vm.removeAsset(usd)
        
        // Then
        XCTAssertFalse(vm.selectedAssets.contains(usd))
        XCTAssertEqual(vm.selectedAssets.count, 1)
    }
    
    @MainActor
    func testFormatRate() {
        // Given
        vm.testInjectCurrentRates([
            "USD": 1.0,
            "EUR": 0.85456,
            "BTC": 42356.89
        ])
        
        // When / Then
        XCTAssertEqual(vm.formatRate(for: "USD"), "1.0000")
        XCTAssertEqual(vm.formatRate(for: "EUR"), "0.854560")
        XCTAssertEqual(vm.formatRate(for: "BTC"), "42356.89")
        XCTAssertEqual(vm.formatRate(for: "JPY"), "N/A")
    }
}
