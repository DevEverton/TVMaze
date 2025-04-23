import Foundation
import SwiftUI

import UIKit
typealias PlatformImage = UIImage

actor ImageLoader {
    static let shared = ImageLoader()
    private var cache = NSCache<NSString, PlatformImage>()
    
    private init() {
        cache.countLimit = 100
    }
    
    func loadImage(from urlString: String) async throws -> PlatformImage {
        // Check cache first
        let key = NSString(string: urlString)
        if let cachedImage = cache.object(forKey: key) {
            return cachedImage
        }
        
        // Load image from URL
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        guard let image = PlatformImage(data: data) else {
            throw NetworkError.decodingError
        }
        
        // Cache the image
        cache.setObject(image, forKey: key)
        
        return image
    }
}

// MARK: - Custom AsyncImageView
struct AsyncImageView<Content: View>: View {
    let url: URL?
    let content: (Image) -> Content
    let placeholder: () -> Content
    
    init(
        url: URL?,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Content
    ) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                content(image)
            case .failure(_):
                placeholder()
            case .empty:
                placeholder()
            @unknown default:
                placeholder()
            }
        }
    }
} 
