//
//  APIService.swift
//  Currency tracker
//
//  Created by Slobodianiuk Oleksandr on 21.04.2025.
//

import Foundation
import Combine

final class APIService: ExchangeRateServiceProtocol {
    
    // MARK: - Constants
    private enum Constants {
        static let appId   = "d577dba2b9a34f019edc9245fe61ca26"
        static let scheme  = "https"
        static let host    = "openexchangerates.org"
        static let path    = "/api/latest.json"
    }
    
    // MARK: - Dependencies
    private let session: URLSession
    init(session: URLSession = .shared) { self.session = session }
    
    // MARK: - ExchangeRateServiceProtocol
    func fetchLatestRates(base _: String = "USD") -> AnyPublisher<ExchangeRate, Error> {
        guard let url = latestRatesURL else {
            return Fail(error: APIError.badURL).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .mapError { APIError.network($0) }
            .validateStatus()
            .decode(type: OXRResponse.self, decoder: JSONDecoder())
            .map(\.asDomain)
            .mapError { APIError.decoding($0) }
            .eraseToAnyPublisher()
    }
    
    func fetchAvailableAssets() -> AnyPublisher<[Asset], Error> {
        Just(Asset.defaultList)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Helpers
    private var latestRatesURL: URL? {
        var c = URLComponents()
        c.scheme = Constants.scheme; c.host = Constants.host; c.path = Constants.path
        c.queryItems = [.init(name: "app_id", value: Constants.appId)]
        return c.url
    }
}
