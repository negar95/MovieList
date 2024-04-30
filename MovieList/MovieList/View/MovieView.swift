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
            AuthorizedAsyncImage(url: movie.posterPath, token: token)
            VStack {
                HStack {
                    Text(movie.title ?? "")
                        .font(.title)
                        .bold()
                        .foregroundStyle(Color.white)
                    Spacer()
                }
                if showOverview {
                    HStack {
                        Text(movie.overview ?? "")
                            .font(.caption)
                            .foregroundStyle(Color.white)
                            .background(.white.opacity(0.2))
                        Spacer()
                    }
                }
            }
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
        }.onTapGesture {
            showOverview = !showOverview
        }
    }

}
