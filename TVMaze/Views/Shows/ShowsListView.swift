import SwiftUI

struct ShowsListView: View {
    @StateObject private var viewModel = ShowsListViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                let isSearchingActive = !viewModel.searchQuery.isEmpty
                let showsToDisplay = isSearchingActive ? viewModel.searchResults.map { $0.show } : viewModel.shows
                
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
                    viewModel.debounceAndSearch(query: newValue)
                }
                .overlay {
                     if viewModel.isSearching {
                         ProgressView("Searching...")
                             .frame(maxWidth: .infinity, maxHeight: .infinity)
                             .background(.ultraThinMaterial)
                     } else if showsToDisplay.isEmpty {
                         if isSearchingActive {
                             Text("No results found for \"\(viewModel.searchQuery)\"")
                                 .foregroundColor(.secondary)
                         } else if !viewModel.isLoading { 
                             Text("No shows loaded yet.")
                                 .foregroundColor(.secondary)
                         }
                     }
                 }
                .alert("Error", isPresented: .constant(viewModel.error != nil), presenting: viewModel.error) {
                    _ in Button("OK") { viewModel.resetSearch() }
                } message: {
                    error in Text(error.localizedDescription)
                }
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
}

#Preview {
    ShowsListView()
} 
