//
//  ExchangeRateServiceProtocol.swift
//  Currency tracker
//
//  Created by Slobodianiuk Oleksandr on 21.04.2025.
//

import Combine
import Foundation

// MARK: - API abstractions
protocol ExchangeRateServiceProtocol {
    /// Latest FX/crypto rates for the given base currency (free‑tier ⇒ always USD).
    func fetchLatestRates(base: String) -> AnyPublisher<ExchangeRate, Error>
    
    /// Static list of assets supported by the app.
    func fetchAvailableAssets() -> AnyPublisher<[Asset], Error>
}

// MARK: - Network‑level errors
enum APIError: LocalizedError {
    case badURL
    case network(URLError)
    case decoding(Error)
    
    var errorDescription: String? {
        switch self {
        case .badURL:            return "The request URL is invalid."
        case .network(let err):  return err.localizedDescription
        case .decoding(let err): return "Unable to decode response: \(err.localizedDescription)"
        }
    }
}

