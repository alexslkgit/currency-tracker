//
//  MockStorageService.swift
//  Currency tracker
//
//  Created by Slobodianiuk Oleksandr on 21.04.2025.
//

import SwiftUI

@testable import Currency_tracker

final class MockStorageService: StorageServiceProtocol {
    var mockSelectedAssets: [Asset] = []
    private(set) var savedAssets: [Asset] = []
    
    func saveSelectedAssets(_ assets: [Asset]) {
        savedAssets = assets
    }
    
    func getSelectedAssets() -> [Asset] { mockSelectedAssets }
}
