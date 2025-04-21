//
//  AddAssetViewModel.swift
//  Currency tracker
//
//  Created by Slobodianiuk Oleksandr on 21.04.2025.
//

import Foundation
import Combine

final class AddAssetViewModel: ObservableObject {
    
    // MARK: - Constants
    private enum Constants {
        static let popularSymbols = ["USD", "EUR", "GBP", "JPY"]
    }
    
    // MARK: - Published state
    @Published private(set) var allAssets: [Asset] = []
    @Published private(set) var selectedAssets: [Asset] = []
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Dependencies
    private let apiService: ExchangeRateServiceProtocol
    private let storageService: StorageServiceProtocol
    
    // MARK: - Combine
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Computed groups
    var popularAssets: [Asset] { filteredAssets(for: .popular) }
    var cryptoAssets:  [Asset] { filteredAssets(for: .crypto) }
    var otherAssets:   [Asset] { filteredAssets(for: .otherFiat) }
    
    // MARK: - Init
    init(
        apiService: ExchangeRateServiceProtocol = APIService(),
        storageService: StorageServiceProtocol = StorageService()
    ) {
        self.apiService = apiService
        self.storageService = storageService
        loadAssets()
    }
    
    // MARK: - Public API
    func isAssetSelected(_ asset: Asset) -> Bool {
        selectedAssets.contains { $0.symbol == asset.symbol }
    }
    
    func toggleAssetSelection(_ asset: Asset) {
        if isAssetSelected(asset) {
            selectedAssets.removeAll { $0.symbol == asset.symbol }
        } else {
            selectedAssets.append(asset)
        }
        storageService.saveSelectedAssets(selectedAssets)
    }
    
    // MARK: - Private
    fileprivate func loadAssets() {
        isLoading = true
        selectedAssets = storageService.getSelectedAssets()
        
        apiService.fetchAvailableAssets()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] assets in
                self?.allAssets = assets
            }
            .store(in: &cancellables)
    }
    
    private enum FilterKind { case popular, crypto, otherFiat }
    
    private func filteredAssets(for kind: FilterKind) -> [Asset] {
        let base = searchFiltered(allAssets)
        switch kind {
        case .popular:
            return base.filter { Constants.popularSymbols.contains($0.symbol) }
        case .crypto:
            return base.filter { $0.category == .crypto }
        case .otherFiat:
            return base.filter {
                $0.category == .fiat && !Constants.popularSymbols.contains($0.symbol)
            }
        }
    }
    
    private func searchFiltered(_ assets: [Asset]) -> [Asset] {
        guard !searchText.isEmpty else { return assets }
        let lower = searchText.lowercased()
        return assets.filter {
            $0.name.lowercased().contains(lower) || $0.symbol.lowercased().contains(lower)
        }
    }
}

extension AddAssetViewModel {
    func testSetAllAssets(_ list: [Asset])      { allAssets      = list }
    func testSetSelectedAssets(_ list: [Asset]) { selectedAssets = list }
}

#if DEBUG
extension AddAssetViewModel {
    @MainActor
    func testReload() { loadAssets() }
    
    @MainActor
    func testInjectAllAssets(_ list: [Asset]) { allAssets = list }
    
    @MainActor
    func testInjectSelectedAssets(_ list: [Asset]) { selectedAssets = list }
}
#endif
