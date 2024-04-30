//
//  APIError.swift
//  MovieList
//
//  Created by Negar Moshtaghi on 4/29/24.
//

public enum APIError: Error, CustomStringConvertible, Equatable {
    case badRequest
    case authorizationError
    case serverError
    case unknown
    case invalidSelf

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
        case .invalidSelf:
            return "invalid self"
        }
    }
}
