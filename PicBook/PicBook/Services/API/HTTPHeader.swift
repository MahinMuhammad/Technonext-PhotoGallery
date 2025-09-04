//
//  HTTPHeader.swift
//  PicBook
//
//  Created by Md. Mahinur Rahman on 9/4/25.
//

import Foundation

enum HTTPHeader{
    enum Key{
        static let contentType = "Content-Type"
        static let authorization = "Authorization"
    }
    
    enum value{
        static let contentTypeJSON = "application/json"
        static func authorizationToken(_ token: String) -> String{
            return "Bearer \(token)"
        }
    }
    
    static var commonHeaderCollection = [
        HTTPHeader.Key.contentType : HTTPHeader.value.contentTypeJSON,
    ]
}
