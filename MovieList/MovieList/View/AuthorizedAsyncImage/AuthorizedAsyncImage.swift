//
//  AuthorizedAsyncImage.swift
//  MovieList
//
//  Created by Negar Moshtaghi on 4/30/24.
//

import SwiftUI

struct AuthorizedAsyncImage: View {
    @StateObject private var loader = ImageLoader()
    let url: URL?
    let token: String

    var body: some View {
        Group {
            if let image = loader.image {
                image
                    .resizable()
                    .scaledToFill()
            } else if loader.hasError {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
            } else {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
        .onAppear {
            loader.load(url: url, withAuthorization: token)
        }
    }
}
