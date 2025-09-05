//
//  PBAPIService.swift
//  PicBook
//
//  Created by Md. Mahinur Rahman on 9/4/25.
//

import Foundation

final class PBAPIService{
    private let baseURL = AppConfigService.apiBaseURL
    private var session: URLSession
    private let decoder = JSONDecoder()
    
    typealias DataResponse = (data: Data, response: URLResponse)
    
    init(){
        // Configure a cache (e.g., 20 MB memory, 100 MB disk)
        let cache = URLCache(memoryCapacity: 20 * 1024 * 1024,
                             diskCapacity: 100 * 1024 * 1024,
                             diskPath: "PBAPICache")
        URLCache.shared = cache
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        config.urlCache = cache
        self.session = URLSession(configuration: config)
    }
    
    //MARK: - Network Call Methods
    
    /// Generic method for make  a request over network.
    /// - Parameter endpoint: Enpoint that will the request will be made for
    /// - Returns: A Model that is expected from the returned response data
    public func gerenicRequest<T: Decodable>(endpoint: APIEndpoint) async throws -> T {
        let request = try createRequest(with: endpoint)
        let dataResponse: DataResponse = try await session.data(for: request)
        return try responseHandler(dataResponse)
    }
    
    //MARK: - Helper Methods
    
    /// Intercepts the network call and builds a request for that perticular endpoint
    /// - Parameter endpoint: Enpoint that will the request will be made for
    /// - Returns: A custom request for that perticular endpoint
    private func createRequest(with endpoint: APIEndpoint) throws -> URLRequest{
        var url = baseURL.appendingPathComponent(endpoint.path)
        if let queryItems = endpoint.queryItems{
            url = try addQueryItems(queryItems, to: url)
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.cachePolicy = .returnCacheDataElseLoad
        if let headers = endpoint.headers{
            request.allHTTPHeaderFields = headers
        }
        return request
    }
    
    /// Adds query items (Parameters of url) to the url if thereis any
    /// - Parameters:
    ///   - items: URLQueryItems that will be added to the request
    ///   - url: The url that includes base url and endpoint
    /// - Returns: Url with the query items added
    private func addQueryItems(_ items: [URLQueryItem], to url: URL) throws -> URL{
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = items
        guard let resultURL = components?.url else {throw APIError.invalidURL}
        return resultURL
    }
    
    /// Handles the DataResponse accoding the the response statusCode
    /// - Parameter dataResponse: DataResponse recieved from the network call
    /// - Returns: A Model that is decoded from the data recieved over the network call
    private func responseHandler<T: Decodable>(_ dataResponse: DataResponse) throws -> T{
        guard let httpUrlResponse = dataResponse.response as? HTTPURLResponse else {throw APIError.invalidResponse}
        
        switch httpUrlResponse.statusCode{
        case 200..<300:
            return try decoder.decode(T.self, from: dataResponse.data)
        default:
            throw APIError.invalidHTTPStatus(httpUrlResponse.statusCode)
        }
    }
}
