//
//  MovieListViewModel.swift
//  MovieList
//
//  Created by Negar Moshtaghi on 4/30/24.
//

import Combine
import Foundation

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
    @Published var searchText = ""

    private let movieAPI: MovieAPIProtocol
    private var page = 1
    private var searchTask: Task<(), Error>?
    private var cancellables = Set<AnyCancellable>()

    init(movieAPI: MovieAPIProtocol = MovieAPI()) {
        self.movieAPI = movieAPI
        $searchText
            .removeDuplicates()
            .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
            .sink { [weak self] text in
                guard let self else { return }
                if text.isEmpty {
                    clearSearch()
                } else if text.count > 1 {
                    resetForSearch()
                    search()
                }
            }
            .store(in: &cancellables)
    }

    func loadMovies() async {
        paginationState = .loading
            do {
                let moviesList = try await movieAPI.list(page: page)
                appendUniqueMovies(moviesList.results ?? [])
                hasMoreMovies = page < (moviesList.totalPages ?? page)
                paginationState = .idle
                if hasMoreMovies { page += 1 }
            } catch {
                paginationState = .error(message: error.localizedDescription)
            }

    }

    func loadMoreMovies() {
        guard hasMoreMovies else { return }
        if searchText.isEmpty {
            Task {
                await loadMovies()
            }
        } else {
            search()
        }
    }

    func clearSearch() {
        searchTask?.cancel()
        searchTask = nil
        page = 1
        movies = []
        Task {
            await loadMovies()
        }
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
                appendUniqueMovies(moviesSearch.results ?? [])
                hasMoreMovies = page < (moviesSearch.totalPages ?? page)
                paginationState = .idle
                if hasMoreMovies { page += 1 }
            } catch let error {
                if !(error is CancellationError) {
                    paginationState = .error(message: error.localizedDescription)
                }
            }
        }
    }

    private func appendUniqueMovies(_ newMovies: [Movie]) {
        let existingIDs = Set(movies.map { $0.id })
        let unique = newMovies.filter { !existingIDs.contains($0.id) }
        movies.append(contentsOf: unique)
    }
}
