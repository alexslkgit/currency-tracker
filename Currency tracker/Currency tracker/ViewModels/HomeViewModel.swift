//
//  HomeViewModel.swift
//  Currency tracker
//
//  Created by Slobodianiuk Oleksandr on 21.04.2025.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    
    private enum Constants {
        static let baseCurrency                 = "USD"
        static let refreshInterval: TimeInterval = 1
    }
    
    // MARK: - Published state
    @Published private(set) var selectedAssets: [Asset] = []
    @Published private(set) var currentRates:  [String: Double] = [:]
    @Published private(set) var previousRates: [String: Double] = [:]
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Dependencies
    private let apiService: ExchangeRateServiceProtocol
    private let storageService: StorageServiceProtocol
    
    // MARK: - Combine
    private var cancellables = Set<AnyCancellable>()
    private var timerCancellable: AnyCancellable?
    
    // MARK: - Init
    init(
        apiService: ExchangeRateServiceProtocol = APIService(),
        storageService: StorageServiceProtocol  = StorageService()
    ) {
        self.apiService     = apiService
        self.storageService = storageService
        loadSelectedAssets()
    }
    
    // MARK: - Public commands
    
    func startAutoRefresh() {
        stopAutoRefresh()
        timerCancellable = Timer
            .publish(every: Constants.refreshInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.fetchLatestRates() }
    }
    
    func stopAutoRefresh() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }
    
    /// Manual pull‑to‑refresh from the view
    func refreshRates() {
        fetchLatestRates()
    }
    
    /// Sync list after returning from AddAssetView
    func reloadSelectedAssets() {
        loadSelectedAssets()
    }
    
    func removeAsset(_ asset: Asset) {
        selectedAssets.removeAll { $0.symbol == asset.symbol }
        storageService.saveSelectedAssets(selectedAssets)
    }
    
    func formatRate(for symbol: String) -> String {
        guard let rate = currentRates[symbol] else { return "N/A" }
        
        if symbol == Constants.baseCurrency { return "1.0000" }
        
        switch rate {
        case 1_000...:
            return String(format: "%.2f", rate)             // 42 356.89
        case 1..<1_000:
            return String(format: "%.4f", rate)             // 0.8546
        default:
            return String(format: "%.6f", rate)             // 0.000123
        }
    }
    
    func percentChange(for symbol: String) -> String {
        guard
            let current  = currentRates[symbol],
            let previous = previousRates[symbol],
            previous > 0
        else { return "" }
        let change = (current - previous) / previous * 100
        return change >= 0
        ? "+\(change.formatted(.number.precision(.fractionLength(2))))%"
        :  "\(change.formatted(.number.precision(.fractionLength(2))))%"
    }
    
    deinit { stopAutoRefresh() }
    
    // MARK: - Private helpers
    
    private func loadSelectedAssets() {
        selectedAssets = storageService.getSelectedAssets()
        fetchLatestRates()
    }
    
    private func fetchLatestRates() {
        isLoading = true
        
        apiService
            .fetchLatestRates(base: Constants.baseCurrency)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] exchangeRate in
                guard let self else { return }
                
                previousRates = currentRates
                currentRates  = makeRateDict(from: exchangeRate)
                errorMessage  = nil
            }
            .store(in: &cancellables)
    }
    
    private func makeRateDict(from data: ExchangeRate) -> [String: Double] {
        selectedAssets.reduce(into: [Constants.baseCurrency: 1]) { dict, asset in
            dict[asset.symbol] = asset.symbol == Constants.baseCurrency
            ? 1
            : data.rate(for: asset.symbol)
        }
    }
}

#if DEBUG
extension HomeViewModel {
    @MainActor
    func testReload() { reloadSelectedAssets() }
    
    @MainActor
    func testInjectSelectedAssets(_ list: [Asset]) { selectedAssets = list }
    
    @MainActor
    func testInjectCurrentRates(_ dict: [String: Double]) { currentRates = dict }
}
#endif
