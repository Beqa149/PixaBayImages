//
//  ImagesListViewModel.swift
//  ImagesList
//
//  Created by Beqa Baramia on 08.07.24.
//

import Foundation
import RxSwift
import RxCocoa

class ImageListViewModel: ObservableObject {
    
    private var service: ImagesServiceProtocol
    let disposeBag = DisposeBag()

    let query: BehaviorRelay<String> = BehaviorRelay(value: "goldenretriever")
    
    private let imagesRelay: BehaviorRelay<[PixabayImage]> = BehaviorRelay(value: [])
    
    @Published var images: [PixabayImage] = []
    
    init(service: ImagesServiceProtocol) {
        self.service = service
            
        imagesRelay
            .asDriver()
            .drive(imagesBinding) // Bind to @Published
            .disposed(by: disposeBag)
    }
    
    private var imagesBinding: Binder<[PixabayImage]> {
        Binder(self) { viewModel, newImages in
            viewModel.images = newImages
        }
    }
    
    func fetchImages(query: String) -> Completable {
        return service.fetchPhotos(query: "goldenrretiever")
            .flatMapCompletable { [weak self] (response) -> Completable in
                let images = response.hits
                print("Images: \(images)")
                self?.imagesRelay.accept(images)
                return .empty()
            }.catch({ error in
                return .error(error)
            })
    }
    
}

