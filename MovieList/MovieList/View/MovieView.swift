//
//  MovieView.swift
//  MovieList
//
//  Created by Negar Moshtaghi on 4/29/24.
//

import SwiftUI

struct MovieView: View {
    let movie: Movie
    @State var showOverview: Bool = false

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            HStack {
                Spacer()
                AuthorizedAsyncImage(url: movie.posterPath, token: token)
                    .background(Color.gray.opacity(0.5))
                Spacer()
            }
            VStack {
                HStack {
                    Text(movie.title ?? "")
                        .font(.title)
                        .bold()
                        .foregroundStyle(Color.white)
                    Spacer()
                }
                if showOverview {
                    Text(movie.overview ?? "")
                        .font(.caption)
                        .foregroundStyle(Color.white)
                }

            }
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
        }.onTapGesture {
            showOverview = !showOverview
        }
    }
}
