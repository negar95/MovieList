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
            List {
                ForEach(Array(viewModel.movies)) { movie in
                    MovieView(movie: movie)
                }
                if viewModel.hasMoreMovies {
                    lastRowView
                }
            }
            .listStyle(.plain)
        }
        .searchable(text: $viewModel.searchText, prompt: "Search movies")
        .navigationTitle("Movies")
        .onAppear {
            viewModel.loadMovies()
        }
    }

    var lastRowView: some View {
        ZStack(alignment: .center) {
            switch viewModel.paginationState {
            case .loading:
                ProgressView()
            case .idle:
                EmptyView()
            case .error(let error):
                Text(error)
                    .font(.body)
                    .foregroundStyle(Color.red)
            }
        }
        .frame(height: 50)
        .onAppear {
            viewModel.loadMoreMovies()
        }
    }
}
