//
//  GalleryViewModel.swift
//  PicBook
//
//  Created by Md. Mahinur Rahman on 9/5/25.
//

import UIKit
import Photos

@MainActor
final class GalleryViewModel: ObservableObject{
    @Published private(set) var photos: [PhotoModel] = []
    @Published private(set) var isLoading = false
    @Published var error: String?
    @Published var alert: String?
    
    private let client: APIClient
    
    private var page = 1
    private let limit = 15
    private var hasMore = true
    
    private var loadTask: Task<Void, Never>?
    
    init(client: APIClient = PBAPIService()) { self.client = client }
    
    func refresh() {
        page = 1; hasMore = true
        photos.removeAll(); error = nil
        loadTask?.cancel()
        loadTask = Task{await loadPage()}
    }
    
    func loadMoreIfNeeded(currentItem: PhotoModel?) {
        guard let currentItem, hasMore, !isLoading else { return }
        guard let index = photos.firstIndex(where: { $0.id == currentItem.id }) else { return }
        
        let thresholdIndex = max(0, photos.count - 4) // last 2 rows (2 cols * 2 rows = 4)
        if index >= thresholdIndex {
            Task { await loadPage() }
        }
    }
    
    private func loadPage() async {
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
    
    func saveImageToPhotos(_ image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.9) else { return }

        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            guard status == .authorized else { return }
            PHPhotoLibrary.shared().performChanges({
                let req  = PHAssetCreationRequest.forAsset()
                let opts = PHAssetResourceCreationOptions()
                opts.uniformTypeIdentifier = "public.jpeg"   // force JPEG
                req.addResource(with: .photo, data: data, options: opts)
            }, completionHandler: { [weak self] success, error  in
                guard let self else {return}
                if let error{
                    print(error)
                    DispatchQueue.main.async{
                        self.error = "Something went wrong"
                    }
                }else if success{
                    DispatchQueue.main.async{
                        self.alert = "Photo Saved"
                    }
                }
            })
        }
    }
}
