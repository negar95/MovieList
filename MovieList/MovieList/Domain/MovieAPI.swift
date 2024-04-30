//
//  MovieAPI.swift
//  MovieList
//
//  Created by Negar Moshtaghi on 4/29/24.
//

import Combine
import Foundation

protocol MovieAPIProtocol {
    func search(query: String, page: Int) -> AnyPublisher<MovieResponse, Error>
    func list(page: Int) -> AnyPublisher<MovieResponse, Error>
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

    func search(query: String, page: Int) -> AnyPublisher<MovieResponse, Error> {
        return networkManager.request(api: MovieRequest.search(query: query, page: page), retryCount: 2)
            .tryMap { [weak self] data in
                guard let self else { throw APIError.invalidSelf}
                return try self.jsonDecoder.decode(MovieResponse.self, from: data)
            }
            .eraseToAnyPublisher()
    }

    func list(page: Int) -> AnyPublisher<MovieResponse, Error> {
        return networkManager.request(api: MovieRequest.list(page: page), retryCount: 4)
            .tryMap { [weak self] data in
                guard let self else { throw APIError.invalidSelf}
                return try self.jsonDecoder.decode(MovieResponse.self, from: data)
            }
            .eraseToAnyPublisher()
    }
}
