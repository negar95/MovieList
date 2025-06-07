//
//  MovieListView.swift
//  MovieList
//
//  Created by Negar Moshtaghi on 4/30/24.
//

import SwiftUI

struct MovieListView: View {
    @ObservedObject var viewModel: MovieListViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.movies) { movie in
                        MovieView(movie: movie)
                            .onAppear {
                                if movie == viewModel.movies.last {
                                    viewModel.loadMoreMovies()
                                }
                            }
                    }
                    paginationFooter
                }
                .padding()
            }
            .navigationTitle("Movies")
            .searchable(text: $viewModel.searchText, prompt: "Search movies")
            .animation(.easeInOut, value: viewModel.movies.count)
        }
    }

    var paginationFooter: some View {
        ZStack {
            switch viewModel.paginationState {
            case .loading:
                ProgressView().frame(height: 50)
            case .error(let error):
                VStack(spacing: 8) {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                    Button("Retry") {
                        viewModel.loadMoreMovies()
                    }
                    .font(.caption)
                }
                .frame(height: 60)
            case .idle:
                EmptyView().frame(height: 10)
            }
        }
    }
}
