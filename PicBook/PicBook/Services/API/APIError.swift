//
//  APIError.swift
//  PicBook
//
//  Created by Md. Mahinur Rahman on 9/4/25.
//

import Foundation

enum APIError: Error {
    case invalidResponse
    case invalidData
    case invalidURL
    case invalidHTTPStatus(Int)
}
