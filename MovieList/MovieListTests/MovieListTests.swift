//
//  MovieListViewModelTests.swift
//  MovieList
//
//  Created by Negar Moshtaghi on 6/7/25.
//

import Foundation
import Testing
@testable import MovieList

@Suite
struct MovieListViewModelTests {

    @Test
    @MainActor
    func testLoadMovies_appendsMovies() async {
        let mockAPI = MockMovieAPI()
        let viewModel = MovieListViewModel(movieAPI: mockAPI)

        await viewModel.loadMovies()

        #expect(viewModel.movies.count == 2)
        #expect(viewModel.movies.contains { $0.title == "Movie A" })
        #expect(viewModel.hasMoreMovies == false)
        #expect(mockAPI.listCalled)
    }

    @Test
    @MainActor
    func testSearch_updatesMoviesWithResults() async {
        let mockAPI = MockMovieAPI()
        let viewModel = MovieListViewModel(movieAPI: mockAPI)

        viewModel.searchText = "Avengers"
        try? await Task.sleep(nanoseconds: 500_000_000) // Wait for debounce

        #expect(viewModel.movies.count == 1)
        #expect(viewModel.movies.first?.title == "Movie C")
        #expect(mockAPI.searchCalled)
    }

    @Test
    @MainActor
    func testClearSearch_resetsAndLoadsDefault() async {
        let mockAPI = MockMovieAPI()
        let viewModel = MovieListViewModel(movieAPI: mockAPI)

        viewModel.searchText = "Anything"
        try? await Task.sleep(nanoseconds: 500_000_000)

        viewModel.searchText = ""
        try? await Task.sleep(nanoseconds: 500_000_000)

        #expect(mockAPI.listCalled)
        #expect(viewModel.searchText.isEmpty)
        #expect(viewModel.movies.count == 2)
    }

    @Test
    @MainActor
    func testNoDuplicateMoviesAdded() async {
        let mockAPI = MockMovieAPI()
        let viewModel = MovieListViewModel(movieAPI: mockAPI)

        await viewModel.loadMovies()
        await viewModel.loadMovies() // simulate second load with same data

        #expect(viewModel.movies.count == 2) // No duplicates
    }

    @Test
    @MainActor
    func testLoadMovies_handlesError() async {
        final class FailingAPI: MovieAPIProtocol {
            func list(page: Int) async throws -> MovieResponse {
                throw URLError(.badServerResponse)
            }

            func search(query: String, page: Int) async throws -> MovieResponse {
                throw URLError(.cannotFindHost)
            }
        }

        let viewModel = MovieListViewModel(movieAPI: FailingAPI())
        await viewModel.loadMovies()

        if case let .error(message) = viewModel.paginationState {
            #expect(!message.isEmpty)
        }
    }
}
