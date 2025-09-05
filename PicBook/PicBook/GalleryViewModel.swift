//
//  GalleryViewModel.swift
//  PicBook
//
//  Created by Md. Mahinur Rahman on 9/5/25.
//

import Foundation

final class GalleryViewModel: ObservableObject{
    @Published private(set) var photos: [PhotoModel] = []
    @Published private(set) var isLoading = false
    @Published var error: String?
    
    private let client: APIClient
    
    private var page = 1
    private let limit = 15
    private var hasMore = true
    
    init(client: APIClient = PBAPIService()) { self.client = client }
    
    func loadPage() async {
        guard !isLoading, hasMore else { return }
        isLoading = true; defer { isLoading = false }
        
        do {
            let endpoint = APIEndpoint.getList(page: page, limit: limit)
            let newPage: [PhotoModel] = try await client.gerenicRequest(endpoint: endpoint)
            let existing = Set(photos.map(\.id))
            let unique = newPage.filter { !existing.contains($0.id) }
            
            if page == 1 { photos = unique } else { photos.append(contentsOf: unique) }
            
            hasMore = newPage.count == limit
            if hasMore { page += 1 }
        } catch {
            self.error = error.localizedDescription
        }
    }
    
}
