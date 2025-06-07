//
//  APIError.swift
//  MovieList
//
//  Created by Negar Moshtaghi on 4/29/24.
//

import Foundation

public enum APIError: Error, Equatable {
    case badRequest
    case authorizationError
    case serverError
    case unknown
}
extension APIError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .badRequest:
            return "bad request"
        case .authorizationError:
            return "authorization error"
        case .serverError:
            return "server error"
        case .unknown:
            return "unknown error"
        }
    }
}
extension APIError: LocalizedError {
    public var errorDescription: String? { description }
}
