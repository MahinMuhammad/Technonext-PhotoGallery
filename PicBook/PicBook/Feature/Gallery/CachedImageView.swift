//
//  CachedImageView.swift
//  PicBook
//
//  Created by Md. Mahinur Rahman on 9/5/25.
//

import SwiftUI
import Combine

struct CachedImageView: View {
    let url: URL?

    @State private var image: UIImage?
    @State private var cancellable: AnyCancellable?
    
    let imageService: PBImageProtocol = PBImageService()
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .foregroundStyle(.secondary.opacity(0.1))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                if let img = image {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .clipped()
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .onAppear {
                cancellable = imageService
                    .imagePublisher(from: url)
                    .receive(on: RunLoop.main)
                    .sink { image = $0 }
            }
            .onDisappear {
                cancellable?.cancel()
                cancellable = nil
            }
            .onChange(of: url) { _ in
                image = nil
                cancellable?.cancel()
                cancellable = imageService
                    .imagePublisher(from: url)
                    .receive(on: RunLoop.main)
                    .sink { image = $0 }
            }
    }
}
