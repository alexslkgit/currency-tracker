//
//  AddAssetViewModelTests.swift
//  Currency tracker
//
//  Created by Slobodianiuk Oleksandr on 21.04.2025.
//
//
//  AddAssetViewModelTests.swift
//  Currency tracker
//
//  Created by Slobodianiuk Oleksandr on 21.04.2025.
//

import XCTest
@testable import Currency_tracker 

@MainActor
final class AddAssetViewModelTests: XCTestCase {
    
    private var vm: AddAssetViewModel!
    private var api: MockAPIService!
    private var store: MockStorageService!
    
    override func setUp() {
        super.setUp()
        api   = MockAPIService()
        store = MockStorageService()
        vm    = AddAssetViewModel(apiService: api, storageService: store)
    }
    
    override func tearDown() {
        vm = nil; api = nil; store = nil
        super.tearDown()
    }
    
    // MARK: - testInitialState
    
    func testInitialState() {
        // Given – ViewModel
        let exp = expectation(description: "initial load finishes")
        
        // When – чекаємо, поки sink встановить isLoading = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Then
            XCTAssertTrue(self.vm.allAssets.isEmpty)
            XCTAssertTrue(self.vm.selectedAssets.isEmpty)
            XCTAssertTrue(self.vm.searchText.isEmpty)
            XCTAssertFalse(self.vm.isLoading)
            XCTAssertNil(self.vm.errorMessage)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
    // MARK: - testLoadAssets
    
    func testLoadAssets() {
        // Given
        api.mockAssets = [
            .init(symbol: "USD", name: "US Dollar", category: .fiat),
            .init(symbol: "BTC", name: "Bitcoin",   category: .crypto)
        ]
        store.mockSelectedAssets = [
            .init(symbol: "USD", name: "US Dollar", category: .fiat)
        ]
        let exp = expectation(description: "loadAssets")
        
        // When
        vm.testReload()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            XCTAssertEqual(self.vm.allAssets.count, 2)
            XCTAssertEqual(self.vm.selectedAssets.count, 1)
            XCTAssertFalse(self.vm.isLoading)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
    // MARK: - testSearchFiltering
    
    func testSearchFiltering() {
        // Given
        vm.testInjectAllAssets([
            .init(symbol: "USD", name: "US Dollar", category: .fiat),
            .init(symbol: "BTC", name: "Bitcoin",   category: .crypto),
            .init(symbol: "ETH", name: "Ethereum",  category: .crypto)
        ])
        
        // When
        vm.searchText = "BT"
        
        // Then
        XCTAssertEqual(vm.cryptoAssets.first?.symbol, "BTC")
        XCTAssertTrue(vm.popularAssets.isEmpty)
    }
    
    // MARK: - testToggleSelection
    
    func testToggleSelection() {
        // Given
        let usd = Asset(symbol: "USD", name: "US Dollar", category: .fiat)
        
        // When – select
        vm.toggleAssetSelection(usd)
        
        // Then – selected
        XCTAssertTrue(vm.isAssetSelected(usd))
        XCTAssertEqual(store.savedAssets.count, 1)
        
        // When – deselect
        vm.toggleAssetSelection(usd)
        
        // Then – deselected
        XCTAssertFalse(vm.isAssetSelected(usd))
        XCTAssertEqual(store.savedAssets.count, 0)
    }
    
    // MARK: - testErrorHandling
    
    func testErrorHandling() {
        // Given
        api.mockError = NSError(domain: "test", code: 404)
        let exp = expectation(description: "error path")
        
        // When
        vm.testReload()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            XCTAssertNotNil(self.vm.errorMessage)
            XCTAssertFalse(self.vm.isLoading)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
}
