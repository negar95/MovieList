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
    @Published var movies: [Movie] = []
    @Published var hasMoreMovies = true
    @Published var paginationState: PaginationState = .idle

    private let movieAPI = MovieAPI()
    private var page = 1

    func loadMovies() {
        paginationState = .loading
        Task {
            do {
                let moviesList = try await movieAPI.list(page: page)
                movies.append(contentsOf: moviesList.results ?? [])
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
        loadMovies()
    }
}
