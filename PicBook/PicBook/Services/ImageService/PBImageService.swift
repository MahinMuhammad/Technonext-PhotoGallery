//
//  PBImageService.swift
//  PicBook
//
//  Created by Md. Mahinur Rahman on 9/5/25.
//

import UIKit

final class PBImageService: PBImageProtocol {

    private let cache: URLCache
    private let session: URLSession

    init() {
        let memoryCapacity = 100 * 1024 * 1024   // 100 MB memory
        let diskCapacity   = 200 * 1024 * 1024   // 200 MB disk
        cache = URLCache(memoryCapacity: memoryCapacity,
                         diskCapacity: diskCapacity,
                         diskPath: "PBImageCache\(AppConfigService.appEnv)")

        let config = URLSessionConfiguration.default
        config.urlCache = cache
        config.requestCachePolicy = .returnCacheDataElseLoad
        session = URLSession(configuration: config)
    }

    func loadImage(from url: URL?, completion: @escaping (UIImage?) -> Void) {
        guard let url else {
            DispatchQueue.main.async { completion(nil) }
            return
        }
        let request = URLRequest(url: url)

        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }

            // Try cache first for faster response
            if let cachedResponse = self.cache.cachedResponse(for: request),
               let image = UIImage(data: cachedResponse.data) {
                let decoded = image.preparingForDisplay()
                DispatchQueue.main.async {
                    completion(decoded)
                }
                return
            }

            // otherwise fetch from network
            let task = self.session.dataTask(with: request) { data, response, error in
                guard let data = data, let response = response,
                      let image = UIImage(data: data), error == nil else {
                    DispatchQueue.main.async { completion(nil) }
                    return
                }
                
                let decoded = image.preparingForDisplay()

                // Save to cache
                let cached = CachedURLResponse(response: response, data: data)
                self.cache.storeCachedResponse(cached, for: request)

                DispatchQueue.main.async {
                    completion(decoded)
                }
            }
            task.resume()
        }
    }
}
