//
//  ImageListView.swift
//  ImagesList
//
//  Created by Beqa Baramia on 08.07.24.
//

import SwiftUI
import RxSwift
import RxCocoa

struct ImageListView: View {
    //@StateObject private var viewModel = ImageListViewModel(service: ImagesService())
    @State var viewModel: ImageListViewModel
    @State private var isLoading: Bool = true

    var body: some View {
        NavigationView {
            if isLoading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                List(viewModel.images, id: \.id) { image in
                    NavigationLink(destination: ItemDetailView(image: image)){
                        ImageRow(image: image)
                            .frame(height: CGFloat(image.previewHeight))
                    }
                }
                .navigationTitle("Pixabay Images")
            }
        }
        .onAppear {
            viewModel.fetchImages(query: "goldenretriever")
                .subscribe(onCompleted: {
                    print("Images fetched successfully")
                    isLoading = false
                }, onError: { error in
                    print("Error fetching images: \(error.localizedDescription)")
                    isLoading = true
                })
                .disposed(by: viewModel.disposeBag)
        }
    }
}

struct ImageRow: View {
    let image: PixabayImage

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            AsyncImage(url: URL(string: image.previewURL!.absoluteString)) { phase in
                switch phase {
                case .success(let img):
                    img
                        .resizable()
                        .scaledToFit()
                        .frame(width: CGFloat(image.previewWidth), height: CGFloat(image.previewHeight))
                        .cornerRadius(10)
                case .failure:
                    Image(systemName: "photo")
                case .empty:
                    ProgressView()
                @unknown default:
                    EmptyView()
                }
            }
            Text("Author: \(image.user)")
                .font(.system(size: 14, weight: .bold))
                .padding(.horizontal, 20)
        }
    }
}
