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

    private let movieAPI: MovieAPIProtocol
    private var page = 1
    private var cancellables = Set<AnyCancellable>()
    private var searchCancellables = Set<AnyCancellable>()

    init(movieAPI: MovieAPIProtocol = MovieAPI()) {
        self.movieAPI = movieAPI
    }

    func loadMovies() {

        let url = URL(string: "http://203.161.38.36/api/v1/radio/stream/68fe584ac273ed66fb1ed2cd15c8e857e7b30b606cd0011f8eb77de0cadfaa19/")!

        let player = HLSAudioStreamer(url: url)
        player.play()

//        paginationState = .loading
//        movieAPI.list(page: page)
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { [weak self] completion in
//                guard let self else { return }
//                switch completion {
//                case .finished:
//                    self.paginationState = .idle
//                case let .failure(error):
//                    self.paginationState = .error(message: error.localizedDescription)
//                }
//            }, receiveValue: { [weak self] moviesList in
//                guard let self else { return }
//                self.movies.formUnion(moviesList.results ?? [])
//                self.hasMoreMovies = self.page < moviesList.totalPages ?? self.page
//                self.paginationState = .idle
//                if self.hasMoreMovies {
//                    self.page += 1
//                }
//            })
//            .store(in: &cancellables)
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
        searchCancellables.forEach { $0.cancel() }
        searchCancellables.removeAll()
        page = 1
        movies = []
        loadMovies()
    }

    func resetForSearch() {
        page = 1
        movies = []
    }

    func search() {
        searchCancellables.forEach { $0.cancel() }
        searchCancellables.removeAll()
        paginationState = .loading
        page = 1
        movieAPI.search(query: searchText, page: page)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .finished:
                    self.paginationState = .idle
                case .failure(let error):
                    if error is CancellationError {
                        print("Search was cancelled")
                    } else {
                        self.paginationState = .error(message: error.localizedDescription)
                    }
                }
            }, receiveValue: { [weak self] moviesSearch in
                guard let self else { return }
                self.movies.formUnion(moviesSearch.results ?? [])
                self.hasMoreMovies = self.page < moviesSearch.totalPages ?? self.page
                if self.hasMoreMovies {
                    self.page += 1
                }
            })
            .store(in: &searchCancellables)
    }
}
