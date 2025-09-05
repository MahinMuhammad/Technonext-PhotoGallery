//
//  APIClient.swift
//  PicBook
//
//  Created by Md. Mahinur Rahman on 9/5/25.
//

import Foundation
import Combine

protocol APIClient: AnyObject {
    func gerenicRequest<T: Decodable>(endpoint: APIEndpoint) async throws -> T
}
