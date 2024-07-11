//
//  ImagesService.swift
//  ImagesList
//
//  Created by Beqa Baramia on 08.07.24.
//

import Foundation
import Alamofire
import RxSwift

protocol ImagesServiceProtocol {
    func fetchPhotos(query: String) -> Single<PixabayResponse>
}

struct APIConstants {
    static let baseURL = "https://pixabay.com/api/"
    static let apiKey = "44794009-b766cd7a28af54ae168aac8a3"
}

class ImagesService: ImagesServiceProtocol {
    private let baseURL = "\(APIConstants.baseURL)?key=\(APIConstants.apiKey)&q=golden+retriever&image_type=photo"//"https://pixabay.com/api/"
    
    func fetchPhotos(query: String) -> Single<PixabayResponse> {
        return Single.create { single in

            let request = AF.request(self.baseURL)
                .validate()
                .responseDecodable(of: PixabayResponse.self) { response in
                    switch response.result {
                    case .success(let pixabayResponse):
                        single(.success(pixabayResponse))
                    case .failure(let error):
                        single(.failure(error))
                    }
                }

            return Disposables.create {
                request.cancel()
            }
        }
    }
}


struct PixabayResponse: Codable {
    let total: Int
    let totalHits: Int
    let hits: [PixabayImage]
}

struct PixabayImage: Codable, Identifiable{
    let id: Int
    let type: String
    let tags: String
    @URLFromString var previewURL: URL?
    let imageWidth: Int
    let imageHeight: Int
    let previewWidth: Int
    let previewHeight: Int
    @URLFromString var largeImageURL: URL?
    let views: Int
    let downloads: Int
    let likes: Int
    let comments: Int
    let collections: Int
    let userId: Int
    let user: String
    

    enum CodingKeys: String, CodingKey {
        case id, type, tags, views, downloads, likes, comments, user, collections
        case userId = "user_id"
        case imageWidth = "imageWidth"
        case imageHeight = "imageHeight"
        case largeImageURL = "largeImageURL"
        case previewURL = "previewURL"
        case previewWidth = "previewWidth"
        case previewHeight = "previewHeight"
    }
}

@propertyWrapper
struct URLFromString: Codable {
    var wrappedValue: URL?

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let urlString = try? container.decode(String.self) {
            wrappedValue = URL(string: urlString)
        } else {
            wrappedValue = nil
        }
    }
}

// Define possible API errors
enum APIError: Error {
    case invalidURL
    case serverError
}
