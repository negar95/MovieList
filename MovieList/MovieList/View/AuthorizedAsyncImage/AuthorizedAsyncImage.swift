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
                    .aspectRatio(contentMode: .fill)
            } else {
                ProgressView()
                    .frame(width: 300, height: 400)
            }
        }
        .onAppear {
            loader.load(url: url, withAuthorization: token)
        }
    }
}
