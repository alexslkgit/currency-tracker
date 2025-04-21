//
//  MockAPIService.swift
//  Currency tracker
//
//  Created by Slobodianiuk Oleksandr on 21.04.2025.
//

import SwiftUI

@testable import Currency_tracker
import Combine

final class MockAPIService: ExchangeRateServiceProtocol {
    var mockAssets: [Asset]?
    var mockExchangeRate: ExchangeRate?
    var mockError: Error?
    
    func fetchLatestRates(base _: String) -> AnyPublisher<ExchangeRate, Error> {
        if let err = mockError {
            return Fail(error: err).eraseToAnyPublisher()
        }
        if let rate = mockExchangeRate {
            return Just(rate).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        return Fail(error: NSError(domain: "test", code: 0)).eraseToAnyPublisher()
    }
    
    func fetchAvailableAssets() -> AnyPublisher<[Asset], Error> {
        if let err = mockError {
            return Fail(error: err).eraseToAnyPublisher()
        }
        if let list = mockAssets {
            return Just(list).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
