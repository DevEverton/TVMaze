import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(Int)
    case unknown(Error)
}

protocol NetworkManaging {
    func fetch<T: Decodable>(_ endpoint: String, queryItems: [URLQueryItem]?) async throws -> T
}

extension NetworkManaging {
    func fetch<T: Decodable>(_ endpoint: String) async throws -> T {
        try await fetch(endpoint, queryItems: nil)
    }
}

final class NetworkManager: NetworkManaging {
    static let shared = NetworkManager()
    private let baseURL = "https://api.tvmaze.com"
    
    private init() {}
    
    func fetch<T: Decodable>(_ endpoint: String, queryItems: [URLQueryItem]? = nil) async throws -> T {
        guard var urlComponents = URLComponents(string: baseURL + endpoint) else {
            throw NetworkError.invalidURL
        }
        
        if let queryItems = queryItems {
            urlComponents.queryItems = queryItems
        }
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingError
            }
        case 400...499:
            throw NetworkError.serverError(httpResponse.statusCode)
        case 500...599:
            throw NetworkError.serverError(httpResponse.statusCode)
        default:
            throw NetworkError.invalidResponse
        }
    }
} 
