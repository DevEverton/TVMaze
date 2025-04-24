import SwiftUI

struct ShowsListView: View {
    @StateObject private var viewModel = ShowsListViewModel()
    
    private var isSearchingActive: Bool {
        !viewModel.searchQuery.isEmpty
    }
    
    private var showsToDisplay: [Show] {
        isSearchingActive ? viewModel.searchResults.map { $0.show } : viewModel.shows
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(showsToDisplay) { show in
                    ShowCardView(show: show)
                        .onAppear {
                            if show.id == showsToDisplay.last?.id && !isSearchingActive && !viewModel.isLoading {
                                Task {
                                    await viewModel.loadNextPage()
                                }
                            }
                        }
                        .listRowInsets(EdgeInsets())
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                }
                
                if viewModel.isLoading && !isSearchingActive {
                    HStack {
                        Spacer()
                        ProgressView()
                            .padding()
                        Spacer()
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .navigationTitle("TVMaze")
            .searchable(text: $viewModel.searchQuery, prompt: "Search Shows")
            .onChange(of: viewModel.searchQuery) { oldValue, newValue in
                if !viewModel.searchQuery.isEmpty {
                    viewModel.debounceAndSearch(query: newValue)
                }
            }
            .overlay {
                if viewModel.isSearching {
                    ProgressView("Searching...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.ultraThinMaterial)
                } else if showsToDisplay.isEmpty {
                    if isSearchingActive {
                        contentUnavailableView(label: "No shows found", systemImage: "tray.fill", description: "No shows found for \"\(viewModel.searchQuery)\"")   
                    } else if !viewModel.isLoading {
                        contentUnavailableView(label: "No shows loaded", systemImage: "tv", description: "Shows will appear here")
                    } else if viewModel.shows.isEmpty && !viewModel.isLoading {
                        contentUnavailableView(label: "No TV Shows", systemImage: "tv.slash", description: "There are no TV shows available at the moment")
                    }
                }
            }
            .alert("Error", isPresented: .constant(viewModel.error != nil), presenting: viewModel.error) {
                _ in Button("OK") { viewModel.resetSearch() }
            } message: {
                error in Text(error.localizedDescription)
            }
        }
        .onAppear {
            if viewModel.shows.isEmpty && viewModel.searchQuery.isEmpty {
                Task {
                    await viewModel.loadInitialPage()
                }
            }
        }
    }
    
    private func contentUnavailableView(label: String, systemImage: String, description: String) -> some View {
        ContentUnavailableView {
            Label(label, systemImage: systemImage)
        } description: {
            Text(description)
        }
    }
}

#Preview {
    ShowsListView()
} 
