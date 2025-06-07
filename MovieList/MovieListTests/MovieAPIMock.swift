//
//  MovieAPIMock.swift
//  MovieList
//
//  Created by Negar Moshtaghi on 6/7/25.
//

@testable import MovieList

// MARK: - Mock API
final class MockMovieAPI: MovieAPIProtocol {
    var listCalled = false
    var searchCalled = false

    func list(page: Int) async throws -> MovieResponse {
        listCalled = true
        return MovieResponse(
            page: 1,
            results: [
                Movie(id: 1, posterPath: nil, overview: "Overview A", title: "Movie A"),
                Movie(id: 2, posterPath: nil, overview: "Overview B", title: "Movie B")
            ],
            totalPages: 1,
            totalResults: 2
        )
    }

    func search(query: String, page: Int) async throws -> MovieResponse {
        searchCalled = true
        return MovieResponse(
            page: 1,
            results: [
                Movie(id: 3, posterPath: nil, overview: "Overview C", title: "Movie C")
            ],
            totalPages: 1,
            totalResults: 1
        )
    }
}
