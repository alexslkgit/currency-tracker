//
//  OXRResponse.swift
//  Currency tracker
//
//  Created by Slobodianiuk Oleksandr on 21.04.2025.
//

import Combine
import Foundation

struct OXRResponse: Decodable {
    let timestamp: Int
    let base: String
    let rates: [String: Double]
}

extension OXRResponse {
    var asDomain: ExchangeRate {
        .init(
            base: base,
            date: Date(timeIntervalSince1970: TimeInterval(timestamp)),
            rates: rates
        )
    }
}

// Publisher+ValidateStatus.swift

extension Publisher where Output == (data: Data, response: URLResponse) {
    func validateStatus() -> AnyPublisher<Data, APIError> {
        tryMap { output in
            guard
                let http = output.response as? HTTPURLResponse,
                200..<300 ~= http.statusCode
            else { throw URLError(.badServerResponse) }
            return output.data
        }
        .mapError { APIError.network($0 as? URLError ?? URLError(.unknown)) }
        .eraseToAnyPublisher()
    }
}
