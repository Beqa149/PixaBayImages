//
//  ItemDetailView.swift
//  ImagesList
//
//  Created by Beqa Baramia on 08.07.24.
//

import SwiftUI

struct ItemDetailView: View {
    let image: PixabayImage
    
    var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                ImageSection(image: image)
                    .padding()
                InfoSection(image: image)
                    .padding()
            }
            .padding()
            .navigationTitle("Image Details")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct InfoSection: View {
    let image: PixabayImage
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Info:")
                .font(.title)
            
            Text("Author: \(image.user)")
                .font(.title2)
            
            Text("Views: \(image.views)")
                .font(.title2)
            
            Text("Likes: \(image.likes)")
                .font(.title2)
            
            Text("Comments: \(image.comments)")
                .font(.title2)
            
            Text("Collections: \(image.collections)")
                .font(.title2)
            
            Text("Downloads: \(image.downloads)")
                .font(.title2)
        }
    }
}

struct ImageSection: View {
    let image: PixabayImage
    
    var body: some View {
        
        AsyncImage(url: URL(string: image.largeImageURL!.absoluteString)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
            case .failure:
                Image(systemName: "photo")
            @unknown default:
                EmptyView()
            }
        }
        
        VStack(alignment: .leading, spacing: 0) {
            Text("Size: \(image.imageWidth) x \(image.imageHeight)")
                .font(.title2)
            
            Text("Type: \(image.type)")
                .font(.title2)
            
            Text("Tags: \(image.tags)")
                .font(.title2)
        }
    }
}
