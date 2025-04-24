import Foundation
import Combine

@MainActor
final class EpisodeDetailViewModel: ObservableObject {
    @Published private(set) var episode: Episode?
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    private let episodeId: Int
    private let service: TVMazeServiceProtocol
    
    init(episodeId: Int, service: TVMazeServiceProtocol = TVMazeService()) {
        self.episodeId = episodeId
        self.service = service
    }
    
    func loadEpisodeDetails() async {
        isLoading = true
        error = nil
        
        do {
            episode = try await service.fetchEpisodeDetails(id: episodeId)
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
} 