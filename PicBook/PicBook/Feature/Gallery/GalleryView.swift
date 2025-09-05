//
//  GalleryView.swift
//  PicBook
//
//  Created by Md. Mahinur Rahman on 9/5/25.
//

import SwiftUI

struct GalleryView: View {
    @StateObject private var viewModel = GalleryViewModel()
    @State private var fullImage: UIImage?
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        NavigationStack{
            ZStack{
                ScrollView{
                    LazyVGrid(columns: columns, spacing: 12){
                        ForEach(viewModel.photos){ photo in
                            
                            ZStack(alignment: .bottomLeading) {
                                CachedImageView(url: photo.downloadURL){ image in
                                    guard let image else {return}
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                        fullImage = image
                                    }
                                }
                                
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
                
                // Fullscreen overlay for image
                if let img = fullImage {
                    ZStack{
                        Color.black.opacity(0.95)
                            .ignoresSafeArea()
                            .transition(.opacity)
                            .onTapGesture { withAnimation { fullImage = nil } }
                        
                        FullCoverImageView(image: img)
                            .transition(.scale.combined(with: .opacity))
                            .zIndex(1)
                    }
                    .overlay(alignment: .bottom){
                        HStack{
                            Button{
                                
                            }label: {
                                HStack{
                                    Image(systemName: "bookmark")
                                        .resizable()
                                        .frame(width: 23, height: 23)
                                    Text("Save")
                                        .font(.title2)
                                }
                            }
                            
                            Spacer()
                            
                            Button{
                                
                            }label: {
                                Image(systemName: "arrowshape.turn.up.right")
                                    .resizable()
                                    .frame(width: 23, height: 23)
                                Text("Share")
                                    .font(.title2)
                            }
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 30)
                    }
                }
                
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.9), value: fullImage != nil)
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
