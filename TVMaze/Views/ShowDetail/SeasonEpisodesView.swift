import SwiftUI

struct SeasonEpisodesView: View {
    @StateObject private var viewModel: SeasonEpisodesViewModel
    @State private var episodeToShow: Episode?
    
    init(seasonId: Int) {
        _viewModel = StateObject(wrappedValue: SeasonEpisodesViewModel(seasonId: seasonId))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Episodes")
                .font(.headline)
                .padding(.top, 8)
            
            if viewModel.isLoading {
                episodesList
                    .overlay(
                        ProgressView("Loading details...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.ultraThinMaterial)
                    )
            } else if viewModel.episodes.isEmpty {
                emptyEpisodesView
            } else {
                episodesList
            }
        }
        .onAppear {
            Task {
                await viewModel.loadEpisodes()
            }
        }
        .onChange(of: viewModel.seasonId) { oldValue, newValue in
            Task {
                await viewModel.loadEpisodes()
            }
        }
        .sheet(item: $episodeToShow) { episode in
            EpisodeDetailView(episodeId: episode.id)
        }
        .alert("Error", isPresented: .constant(viewModel.error != nil), presenting: viewModel.error) { _ in
            Button("OK") { }
        } message: { error in
            Text(error.localizedDescription)
        }
    }
    
    private var emptyEpisodesView: some View {
        ContentUnavailableView {
            Label("No episodes available", systemImage: "tv.slash")
        } description: {
            Text("Episodes will appear here")
        }
    }
    
    private var episodesList: some View {
        LazyVStack(alignment: .leading, spacing: 16) {
            ForEach(viewModel.episodes) { episode in
                episodeRow(episode: episode)
            }
        }
    }
    
    private func episodeRow(episode: Episode) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(episode.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Spacer()
                
                if let number = episode.number {
                    Text("Ep. \(number)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(width: 50, alignment: .leading)
                } else {
                    Text("Special")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(width: 70, alignment: .leading)
                }
            }
            
            if let imageUrl = episode.image?.medium {
                AsyncImage(url: URL(string: imageUrl)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 150)
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    case .failure, .empty:
                        PlaceholderImageView(systemName: "tv.slash")
                    default:
                        PlaceholderImageView()
                    }
                }
            } else {
                PlaceholderImageView(systemName: "tv.slash")
            }
            
            if !episode.summary.isEmpty {
                Text(episode.summary)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Divider()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            episodeToShow = episode
        }
    }
}

#Preview {
    SeasonEpisodesView(seasonId: 1)
        .padding()
}
