import Foundation

protocol TVMazeServiceProtocol {
    func fetchShows(page: Int) async throws -> [Show]
    func searchShows(query: String) async throws -> [SearchResult]
    func fetchShowDetails(id: Int) async throws -> ShowDetails
    func fetchSeasons(showId: Int) async throws -> [Season]
    func fetchEpisodes(seasonId: Int) async throws -> [Episode]
    func fetchEpisodeDetails(id: Int) async throws -> Episode
}

// MARK: - Service Implementation
final class TVMazeService: TVMazeServiceProtocol {
    private let networkManager: NetworkManaging
    
    init(networkManager: NetworkManaging = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchShows(page: Int) async throws -> [Show] {
        let queryItems = [URLQueryItem(name: "page", value: String(page))]
        return try await networkManager.fetch("/shows", queryItems: queryItems)
    }
    
    func searchShows(query: String) async throws -> [SearchResult] {
        let queryItems = [URLQueryItem(name: "q", value: query)]
        return try await networkManager.fetch("/search/shows", queryItems: queryItems)
    }
    
    func fetchShowDetails(id: Int) async throws -> ShowDetails {
        return try await networkManager.fetch("/shows/\(id)")
    }
    
    func fetchSeasons(showId: Int) async throws -> [Season] {
        return try await networkManager.fetch("/shows/\(showId)/seasons")
    }
    
    func fetchEpisodes(seasonId: Int) async throws -> [Episode] {
        return try await networkManager.fetch("/seasons/\(seasonId)/episodes")
    }
    
    func fetchEpisodeDetails(id: Int) async throws -> Episode {
        return try await networkManager.fetch("/episodes/\(id)")
    }
} 
