//
//  APIClient.swift
//  PicBook
//
//  Created by Md. Mahinur Rahman on 9/5/25.
//

import Foundation
import Combine

protocol APIClient {
    func gerenicRequest<T: Decodable>(endpoint: APIEndpoint) async throws -> T
}

/// We do not need the combine at all we could have used the built in async await
/// Combine is just being used to meet the task requirement
extension APIClient {
    func requestPublisher<T: Decodable>(endpoint: APIEndpoint) -> AnyPublisher<T, Error> {
        Deferred {
            Future { promise in
                Task {
                    do { let v: T = try await self.gerenicRequest(endpoint: endpoint); promise(.success(v)) }
                    catch { promise(.failure(error)) }
                }
            }
        }.eraseToAnyPublisher()
    }
}
