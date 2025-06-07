//
//  NetworkManager.swift
//  MovieList
//
//  Created by Negar Moshtaghi on 4/29/24.
//

import Foundation

public protocol NetworkManagerProtocol {
    func request(_ request: RequestProtocol, retryCount: Int) async throws -> (Data, URLResponse)
}

public final class NetworkManager: NetworkManagerProtocol, @unchecked Sendable {
    public static let shared = NetworkManager()
    private let urlSession: URLSession
    private init(config: URLSessionConfiguration = .default) {
        self.urlSession = URLSession(configuration: config)
    }
    public func request(_ request: RequestProtocol, retryCount: Int) async throws -> (Data, URLResponse) {
        let apiRequest = try request.urlRequest()
        var lastError: Error = APIError.unknown

        for retryIndex in 0 ..< retryCount {
            try Task.checkCancellation()
            do {
                let (data, response) = try await urlSession.data(for: apiRequest)
                return try request.verifyResponse(data: data, response: response)
            } catch let apiError as APIError where [.badRequest, .authorizationError].contains(apiError) {
                throw apiError
            } catch where retryIndex < retryCount - 1 {
                // Exponential backoff with 2 ^ retryIndex multiplier
                try await Task.sleep(nanoseconds: request.retryDelay * UInt64(pow(2, Double(retryIndex))))
                lastError = error
                continue
            } catch {
                throw error
            }
        }

        throw lastError
    }
}
