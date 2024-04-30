//
//  MovieListViewModel.swift
//  MovieList
//
//  Created by Negar Moshtaghi on 4/30/24.
//

import SwiftUI

enum PaginationState {
    case idle
    case loading
    case error(message: String)
}

@MainActor
class MovieListViewModel: ObservableObject {
    @Published var movies = Set<Movie>()
    @Published var hasMoreMovies = true
    @Published var paginationState: PaginationState = .idle
    @Published var searchText = "" {
        didSet {
            if !oldValue.isEmpty && searchText.isEmpty {
                clearSearch()
            } else if searchText.count > 1 {
                resetForSearch()
                search()
            }
        }
    }

    private let movieAPI = MovieAPI()
    private var page = 1
    private var searchTask: Task<(), Error>?

    func loadMovies() {
        paginationState = .loading
        Task {
            do {
                let moviesList = try await movieAPI.list(page: page)
                movies.formUnion(moviesList.results ?? [])
                hasMoreMovies = page < moviesList.totalPages ?? page
                paginationState = .idle
                if hasMoreMovies { page = page + 1 }
            } catch {
                paginationState = .error(message: error.localizedDescription)
            }
        }
    }

    func loadMoreMovies() {
        guard hasMoreMovies else { return }
        if searchText.isEmpty {
            loadMovies()
        } else {
            search()
        }
    }

    func clearSearch() {
        searchTask?.cancel()
        searchTask = nil
        page = 1
        movies = []
        loadMovies()
    }

    func resetForSearch() {
        page = 1
        movies = []
    }

    func search() {
        searchTask?.cancel()
        searchTask = nil
        paginationState = .loading
        page = 1
        searchTask = Task {
            do {
                let moviesSearch = try await movieAPI.search(query: searchText, page: page)
                movies.formUnion(moviesSearch.results ?? [])
                hasMoreMovies = page < moviesSearch.totalPages ?? page
                paginationState = .idle
                if hasMoreMovies { page = page + 1 }
            } catch let error {
                if let _ = error as? CancellationError {
                    print("Task is cancelled")
                } else {
                    paginationState = .error(message: error.localizedDescription)
                }
            }
        }
    }
}
