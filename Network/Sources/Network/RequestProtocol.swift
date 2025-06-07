//
//  RequestProtocol.swift
//  MovieList
//
//  Created by Negar Moshtaghi on 4/29/24.
//

import Foundation

public typealias RequestHeaders = [String: String]
public typealias RequestParameters = [String: Any]
public enum RequestMethod: String { case get = "GET" }

public protocol RequestProtocol {
    /// The root base URL (e.g. "https://api.themoviedb.org/3")
    var baseURL: String { get }

    /// The endpoint path (e.g. "/movie/popular")
    var path: String { get }

    /// HTTP method for the request
    var method: RequestMethod { get }

    /// Query parameters for GET requests
    var parameters: RequestParameters? { get }

    /// Headers to include in the request
    var headers: RequestHeaders? { get }

    /// How long the request should wait before timing out
    var timeoutInterval: TimeInterval { get }

    /// Delay between retry attempts, in nanoseconds
    var retryDelay: UInt64 { get }

    func urlRequest() throws -> URLRequest
    func verifyResponse(data: Data, response: URLResponse) throws -> (Data, URLResponse)
}

extension RequestProtocol {
    private var queryItems: [URLQueryItem]? {
        guard let parameters = parameters else { return nil }
        return parameters.map { (key: String, value: Any) -> URLQueryItem in
            let valueString = String(describing: value)
            return URLQueryItem(name: key, value: valueString)
        }
    }

    private func url() throws -> URL {
        guard var urlComponents = URLComponents(string: baseURL) else { throw APIError.badRequest }
        urlComponents.path = urlComponents.path + path
        urlComponents.queryItems = queryItems
        guard let finalURL = urlComponents.url else { throw APIError.badRequest }
        return finalURL
    }

   public func urlRequest() throws -> URLRequest {
        let url = try url()
        var request = URLRequest(url: url, timeoutInterval: timeoutInterval)
        request.httpMethod = method.rawValue
        headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        return request
    }

    public func verifyResponse(data: Data, response: URLResponse) throws -> (Data, URLResponse) {
        guard let httpResponse = response as? HTTPURLResponse else { throw APIError.unknown }
        switch httpResponse.statusCode {
        case 200...299:
            return (data, response)
        case 401:
            throw APIError.authorizationError
        case 400...499:
            throw APIError.badRequest
        case 500...599:
            throw APIError.serverError
        default:
            throw APIError.unknown
        }
    }
}
