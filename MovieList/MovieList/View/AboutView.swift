//
//  AboutView.swift
//  MovieList
//
//  Created by Negar Moshtaghi on 4/30/24.
//

import SwiftUI

struct AboutView: View {
    private let appVersion: String = {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }()

    var body: some View {
        VStack(alignment: .center, spacing: 20) {

            Image(systemName: "info.circle")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundStyle(.secondary)
                .padding(.bottom)
                .padding(.bottom)
            HStack {
                Text("Movie List")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.primary)

                Text("(v\(appVersion))")
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .padding(.horizontal)

            Text("This app uses \"themoviedb.org\" to let you search for movies and view their overviews.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.leading)
                .padding(.horizontal)

            Spacer()
            Text("by  [Negar Moshtaghi](negarmoshtaghi@gmail.com)")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("About")
    }
}

#Preview {
    NavigationView {
        AboutView()
    }
}
