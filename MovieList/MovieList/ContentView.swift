//
//  ContentView.swift
//  MovieList
//
//  Created by Negar Moshtaghi on 4/29/24.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        TabView {
            MovieListView(viewModel: MovieListViewModel())
                .tabItem { Image(systemName: "movieclapper") }
            AboutView()
                .tabItem { Image(systemName: "info.circle") }
        }
    }
}
