//
//  ZoomableImage.swift
//  PicBook
//
//  Created by Md. Mahinur Rahman on 9/5/25.
//

import SwiftUI

struct FullCoverImageView: View {
    let image: UIImage
    @State private var scale: CGFloat = 1
    @State private var last: CGFloat = 1
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .scaleEffect(scale)
            .offset(offset)
            .gesture(
                MagnificationGesture() // pintch to zoon
                    .onChanged { value in
                        scale = clamp(last * value, min: 1, max: 4)
                    }
                    .onEnded { _ in last = scale }
            )
            .onTapGesture(count: 2) {    // double tap to toggle zoom
                withAnimation(.spring) {
                    if scale > 1 { scale = 1; last = 1; offset = .zero; lastOffset = .zero }
                    else { scale = 2; last = 2 }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
    }
    
    private func clamp(_ v: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
        Swift.max(min, Swift.min(max, v))
    }
}
