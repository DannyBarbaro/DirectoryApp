//
//  ImageCache.swift
//  BlockEmployeeDirectory
//
//  Created by Danny on 2/2/23.
//

import Foundation
import SwiftUI
import UIKit

/// Image Caching protocol to allow mocking for data in testing
protocol ImageCaching {
    func getImage(urlString: String) async -> Image
    func cachedImage(key: String) -> UIImage?
    func cacheImageData(key: String, data: Data)
}

/// A cache designed to store the Image at a given URL
struct ImageCache: ImageCaching {
    
    private let networkProvider: NetworkProviding
    private let imageCache: NSCache<NSString, UIImage>
    
    /// Inject the NetworkingProvider to the image cache and create an empty image cache
    init(networkProvider: NetworkProviding = NetworkProvider()) {
        self.networkProvider = networkProvider
        self.imageCache = NSCache<NSString, UIImage>()
    }
        
    func getImage(urlString: String) async -> Image {
        if let cachedImage = cachedImage(key: urlString) {
            return Image(uiImage: cachedImage)
        } else {
            do {
                let data = try await networkProvider.fetchImageAt(urlString: urlString)
                cacheImageData(key: urlString, data: data)
                if let img = UIImage(data: data) {
                    return Image(uiImage: img)
                } else {
                    return Image("blank-profile")
                }
            } catch {
                print(error.localizedDescription)
                return Image("blank-profile")
            }
        }
    }
    
    internal func cachedImage(key: String) -> UIImage? {
        return self.imageCache.object(forKey: NSString(string: key))
    }
    
    internal func cacheImageData(key: String, data: Data) {
        if let img = UIImage(data: data) {
            self.imageCache.setObject(img, forKey: NSString(string: key))
        }
    }
}
