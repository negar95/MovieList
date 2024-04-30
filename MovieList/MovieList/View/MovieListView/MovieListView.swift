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
        List {
            ForEach(viewModel.movies) { movie in
                MovieView(movie: movie)
            }
            if viewModel.hasMoreMovies {
                lastRowView
            }
        }
        .listStyle(.plain)
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
