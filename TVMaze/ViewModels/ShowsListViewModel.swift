import Foundation
import Combine

@MainActor
final class ShowsListViewModel: ObservableObject {
    @Published private(set) var shows: [Show] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    @Published private(set) var searchResults: [SearchResult] = []
    @Published var searchQuery = ""
    
    private var currentPage = 0
    private var canLoadMorePages = true
    private var searchTask: Task<Void, Never>?
    private let service: TVMazeServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(service: TVMazeServiceProtocol = TVMazeService()) {
        self.service = service
        setupSearchSubscription()
    }
    
    private func setupSearchSubscription() {
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }
    
    func loadInitialPage() async {
        await loadNextPage()
    }
    
    func loadNextPage() async {
        guard !isLoading && canLoadMorePages else { return }
        
        isLoading = true
        error = nil
        
        do {
            let newShows = try await service.fetchShows(page: currentPage)
            if newShows.isEmpty {
                canLoadMorePages = false
            } else {
                shows.append(contentsOf: newShows)
                currentPage += 1
            }
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    private func performSearch(query: String) {
        searchTask?.cancel()
        
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        searchTask = Task { [weak self] in
            guard let self = self else { return }
            
            do {
                let results = try await service.searchShows(query: query)
                if !Task.isCancelled {
                    await MainActor.run {
                        self.searchResults = results
                    }
                }
            } catch {
                if !Task.isCancelled {
                    await MainActor.run {
                        self.error = error
                    }
                }
            }
        }
    }
    
    func resetSearch() {
        searchQuery = ""
        searchResults = []
        error = nil
    }
} 