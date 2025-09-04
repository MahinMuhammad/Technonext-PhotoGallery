//
//  APIEndpoint.swift
//  PicBook
//
//  Created by Md. Mahinur Rahman on 9/4/25.
//

import Foundation

enum APIEndpoint {
    case getList(page: Int, limit: Int)
}

extension APIEndpoint {
    
    var method: HTTPMethod {
        switch self {
        case .getList:
            return .get
        }
    }
    
    var queryItems: [URLQueryItem]? {
            switch self {
            case let .getList(page, limit):
                return [
                    URLQueryItem(name: "page", value: String(page)),
                    URLQueryItem(name: "limit", value: String(limit))
                ]
            }
        }
    
    var path: String {
        switch self {
        case .getList:
            return "/v2/list"
        }
    }
    
    var headers: [String : String]? {
        switch self{
        case .getList:
            return nil
        }
    }
}
