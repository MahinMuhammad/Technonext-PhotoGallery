//
//  GalleryViewModel.swift
//  PicBook
//
//  Created by Md. Mahinur Rahman on 9/5/25.
//

import Foundation
import Combine

final class GalleryViewModel: ObservableObject{
    @Published private(set) var photos: [PhotoModel] = []
    @Published private(set) var isLoading = false
    @Published var error: String?
    
    private let client: APIClient
    private var cancellables = Set<AnyCancellable>()
    
    private var page = 1
    private let limit = 15
    private var hasMore = true
    
    init(client: APIClient = PBAPIService()) { self.client = client }
    
    private func loadPage() {
        guard !isLoading, hasMore else { return }
        isLoading = true
        
        let endpoint = APIEndpoint.getList(page: page, limit: limit)
        
        client.requestPublisher(endpoint: endpoint)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case .failure(let err) = completion { self.error = err.localizedDescription }
            } receiveValue: { [weak self] (newPage: [PhotoModel]) in
                guard let self else { return }
                let existing = Set(self.photos.map(\.id))
                let unique = newPage.filter { !existing.contains($0.id) }
                
                if self.page == 1 { self.photos = unique }
                else { self.photos.append(contentsOf: unique) }
                
                self.hasMore = newPage.count == self.limit
                if self.hasMore { self.page += 1 }
            }
            .store(in: &cancellables)
    }
    
}
