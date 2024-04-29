//
//  MovieAPI.swift
//  MovieList
//
//  Created by Negar Moshtaghi on 4/29/24.
//

import Foundation

protocol MovieAPIProtocol {
    func search(query: String, page: Int) async throws -> MovieResponse
    func list(page: Int) async throws -> MovieResponse
}

final class MovieAPI: MovieAPIProtocol {
    private let networkManager: NetworkManagerProtocol
    private let jsonDecoder: JSONDecoder

    init(
        networkManager: NetworkManagerProtocol = NetworkManager.shared,
        jsonDecoder: JSONDecoder = JSONDecoder()
    ) {
        self.networkManager = networkManager
        self.jsonDecoder = jsonDecoder
    }

    func search(query: String, page: Int) async throws -> MovieResponse {
        let (data, _) = try await networkManager.request(api: MovieRequest.search(query: query, page: page), retryCount: 2)
        return try jsonDecoder.decode(MovieResponse.self, from: data)
    }
    
    func list(page: Int) async throws -> MovieResponse {
        let (data, _) = try await networkManager.request(api: MovieRequest.list(page: page), retryCount: 4)
        return try jsonDecoder.decode(MovieResponse.self, from: data)
    }
}
