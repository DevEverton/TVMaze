import Foundation
import Combine

@MainActor
final class ShowDetailViewModel: ObservableObject {
    @Published private(set) var showDetails: ShowDetails?
    @Published private(set) var seasons: [Season] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    private let showId: Int
    private let service: TVMazeServiceProtocol
    
    init(showId: Int, service: TVMazeServiceProtocol = TVMazeService()) {
        self.showId = showId
        self.service = service
    }
    
    func loadShowDetails() async {
        isLoading = true
        error = nil
        
        do {
            async let details = service.fetchShowDetails(id: showId)
            async let seasonsList = service.fetchSeasons(showId: showId)
            
            let (showDetails, seasons) = try await (details, seasonsList)
            
            self.showDetails = showDetails
            self.seasons = seasons.sorted { $0.number < $1.number }
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
} 