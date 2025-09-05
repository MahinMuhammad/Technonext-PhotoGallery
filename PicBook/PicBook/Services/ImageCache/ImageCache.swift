//
//  ImageCache.swift
//  PicBook
//
//  Created by Md. Mahinur Rahman on 9/5/25.
//

import UIKit

final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSURL, UIImage>()
    private init() {
        cache.countLimit = 500
        cache.totalCostLimit = 50 * 1024 * 1024 // ~50MB
    }
    func image(for url: URL) -> UIImage? { cache.object(forKey: url as NSURL) }
    func set(_ image: UIImage, for url: URL) {
        let cost: Int
        if let cg = image.cgImage {
            cost = cg.bytesPerRow * cg.height
        } else {
            cost = 1
        }
        cache.setObject(image, forKey: url as NSURL, cost: cost)
    }
}
