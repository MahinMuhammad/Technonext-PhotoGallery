//
//  PBAPIService.swift
//  PicBook
//
//  Created by Md. Mahinur Rahman on 9/4/25.
//

import Foundation

final class PBAPIService{
    private let baseURL = AppConfigService.apiBaseURL
    private var session = URLSession.shared
    private let decoder = JSONDecoder()
    
    typealias DataResponse = (data: Data, response: URLResponse)
    
    
}
