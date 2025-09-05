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
                        RoundedRectangle(cornerRadius: 12)
                            .aspectRatio(1, contentMode: .fit)
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
