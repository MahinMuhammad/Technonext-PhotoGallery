//
//  PBImageProtocol.swift
//  PicBook
//
//  Created by Md. Mahinur Rahman on 9/5/25.
//

import UIKit
import Combine


protocol PBImageProtocol: AnyObject {
    func loadImage(from url: URL?, completion: @escaping (UIImage?) -> Void)
}

extension PBImageProtocol {
    /// Combine wrapper around the existing callback API
    func imagePublisher(from url: URL?) -> AnyPublisher<UIImage?, Never> {
        Future { [weak self] promise in
            guard let self else { return promise(.success(nil)) }
            self.loadImage(from: url) { img in
                promise(.success(img))
            }
        }
        .eraseToAnyPublisher()
    }
}
