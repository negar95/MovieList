//
//  ImageLoader.swift
//  MovieList
//
//  Created by Negar Moshtaghi on 4/30/24.
//

import SwiftUI
import UIKit
import ImageIO

enum ImageCacheError: Error {
    case failedToDecode
}
final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSURL, UIImage>()
    private init() {
        cache.totalCostLimit = 100 * 1024 * 1024
        cache.countLimit = 200
    }
    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }
    func insertImage(_ image: UIImage, for url: URL, cost: Int) {
        cache.setObject(image, forKey: url as NSURL, cost: cost)
    }
}

@MainActor
final class ImageLoader: ObservableObject {
    @Published var image: Image?
    @Published var hasError: Bool = false

    func load(url: URL?, withAuthorization token: String, targetSize: CGSize = CGSize(width: 200, height: 300)) {
        guard let url else { return }

        if let cachedImage = ImageCache.shared.image(for: url) {
            self.image = Image(uiImage: cachedImage)
            return
        }

        Task {
            do {
                var request = URLRequest(url: url)
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                let (data, _) = try await URLSession.shared.data(for: request)
                let image = try downSample(imageData: data, to: targetSize)
                ImageCache.shared.insertImage(image, for: url, cost: data.count)
                self.image = Image(uiImage: image)
            } catch {
                self.hasError = true
            }
        }
    }

    func downSample(imageData: Data, to pointSize: CGSize) throws -> UIImage {
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * UIScreen.main.scale
        let options: [CFString: Any] = [kCGImageSourceShouldCache: false]
        guard let source = CGImageSourceCreateWithData(imageData as CFData, options as CFDictionary) else {
            throw ImageCacheError.failedToDecode
        }
        let downsampleOptions: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ]
        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, downsampleOptions as CFDictionary) else {
            throw ImageCacheError.failedToDecode
        }
        return UIImage(cgImage: cgImage)
    }
}
