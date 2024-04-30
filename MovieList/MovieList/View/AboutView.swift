//
//  AboutView.swift
//  MovieList
//
//  Created by Negar Moshtaghi on 4/30/24.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Text("Movie List")
                .font(.title)
                .foregroundStyle(.primary)
            Text("This is a movie list app, using \"themoviedb.org\". You can search movies and tap on them to read overview.")
                .font(.caption)
                .foregroundStyle(.primary)
        }
    }
}

#Preview {
    AboutView()
}
