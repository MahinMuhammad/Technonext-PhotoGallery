//
//  GalleryView.swift
//  PicBook
//
//  Created by Md. Mahinur Rahman on 9/5/25.
//

import SwiftUI

struct GalleryView: View {
    @StateObject private var viewModel = GalleryViewModel()
    
    private let columns = [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ]
    
    var body: some View {
        NavigationStack{
            ScrollView{
                LazyVGrid(columns: columns, spacing: 12){
                    ForEach(viewModel.photos){ photo in
                        
                        ZStack(alignment: .bottomLeading) {
                            CachedImageView(url: photo.downloadURL)
                            
                            if let author = photo.author {
                                Text(author)
                                    .font(.caption).bold().foregroundStyle(.white)
                                    .padding(.horizontal, 8).padding(.vertical, 4)
                                    .background(.black.opacity(0.45), in: Capsule())
                                    .padding(8)
                            }
                        }
                        .onAppear { viewModel.loadMoreIfNeeded(currentItem: photo) }
                    }
                }
                .padding(12)
            }
            .navigationTitle("PicBook")
            .task {viewModel.refresh()}
            .refreshable {viewModel.refresh()}
            .alert("Error",
                   isPresented: .constant(viewModel.error != nil),
                   actions: { Button("OK") { viewModel.error = nil } },
                   message: { Text(viewModel.error ?? "") })
        }
    }
}

#Preview {
    GalleryView()
}
