//
//  ImageLoader.swift
//  MovieList
//
//  Created by Negar Moshtaghi on 4/30/24.
//

import SwiftUI

final class ImageCache {
    static let shared = NSCache<NSURL, UIImage>()
}

@MainActor
final class ImageLoader: ObservableObject {
    @Published var image: Image?
    @Published var hasError: Bool = false

    func load(url: URL?, withAuthorization token: String) {
        guard let url else { return }

        if let cached = ImageCache.shared.object(forKey: url as NSURL) {
            self.image = Image(uiImage: cached)
            return
        }

        Task {
            do {
                var request = URLRequest(url: url)
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                let (data, _) = try await URLSession.shared.data(for: request)
                guard let uiImage = UIImage(data: data) else {
                    self.hasError = true
                    return
                }

                ImageCache.shared.setObject(uiImage, forKey: url as NSURL)
                self.image = Image(uiImage: uiImage)
            } catch {
                self.hasError = true
            }
        }
    }
}
