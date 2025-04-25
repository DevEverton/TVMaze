import Foundation
import Combine

@MainActor
final class SeasonEpisodesViewModel: ObservableObject {
    @Published private(set) var episodes: [Episode] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    var seasonId: Int
    private let service: TVMazeServiceProtocol
    
    init(seasonId: Int, service: TVMazeServiceProtocol = TVMazeService()) {
        self.seasonId = seasonId
        self.service = service
    }
    
    func loadEpisodes() async {
        isLoading = true
        error = nil
        
        do {
            let episodes = try await service.fetchEpisodes(seasonId: seasonId)
            self.episodes = episodes.sorted { $0.number < $1.number }
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
} 
