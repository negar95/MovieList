//
//  MovieView.swift
//  MovieList
//
//  Created by Negar Moshtaghi on 4/29/24.
//

import SwiftUI

struct MovieView: View {
    let movie: Movie
    @State private var showOverview = false

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AuthorizedAsyncImage(url: movie.posterPath, token: NetworkConstants.token)
                .frame(height: 400)
                .clipped()

            LinearGradient(
                gradient: Gradient(colors: [.black.opacity(0.8), .black.opacity(0.0)]),
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: showOverview ? 400 : 100)
            .clipped()

            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title ?? "Untitled")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .shadow(radius: 2)

                if showOverview {
                    Text(movie.overview ?? "No description available.")
                        .font(.caption)
                        .foregroundStyle(.white)
                        .lineLimit(6)
                        .transition(.opacity)
                        .shadow(radius: 1)
                }
            }
            .padding()
        }
        .cornerRadius(10)
        .onTapGesture {
            withAnimation(.easeInOut) {
                showOverview.toggle()
            }
        }
    }
}
