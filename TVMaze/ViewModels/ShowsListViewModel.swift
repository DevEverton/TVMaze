import Foundation

@MainActor
final class ShowsListViewModel: ObservableObject {
    @Published private(set) var shows: [Show] = []
    @Published private(set) var isLoading = false
    @Published private(set) var isSearching = false
    @Published private(set) var error: Error?
    @Published private(set) var searchResults: [SearchResult] = []
    
    @Published var searchQuery = ""
    
    private var currentPage = 0
    private var searchTask: Task<Void, Error>?
    private let service: TVMazeServiceProtocol
    
    init(service: TVMazeServiceProtocol = TVMazeService()) {
        self.service = service
    }
    
    func debounceAndSearch(query: String) {
        isSearching = true
        searchTask?.cancel()
        
        searchTask = Task {
            try? await Task.sleep(for: .seconds(2))
            guard !Task.isCancelled else { return }
            await performSearch(query: query)
        }
    }
    
    func loadInitialPage() async {
        guard !isSearching else { return }
        await loadNextPage()
    }
    
    func loadNextPage() async {
        guard !isLoading && !isSearching else { return }
        
        isLoading = true
        error = nil
        defer { isLoading = false }
        
        do {
            let newShows = try await service.fetchShows(page: currentPage)
            shows.append(contentsOf: newShows)
            currentPage += 1
        } catch {
            if !isSearching { 
                self.error = error
            }
        }
    }
    
    private func performSearch(query: String) async {
        guard !query.isEmpty else {
            searchResults = []
            isSearching = false
            error = nil
            return
        }
        
        guard !isLoading else { return }
        
        isSearching = true
        error = nil
        defer { isSearching = false }

        do {
            let results = try await service.searchShows(query: query)
            if !Task.isCancelled {
                self.searchResults = results
            }
        } catch {
            if !Task.isCancelled {
                self.error = error
            }
        }
    }
    
    func resetSearch() {
        searchTask?.cancel()
        searchQuery = ""
        searchResults = []
        isSearching = false
        error = nil
    }
} 
