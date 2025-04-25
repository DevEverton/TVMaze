import SwiftUI

struct SeasonEpisodesView: View {
    @StateObject private var viewModel: SeasonEpisodesViewModel
    
    init(seasonId: Int) {
        _viewModel = StateObject(wrappedValue: SeasonEpisodesViewModel(seasonId: seasonId))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Episodes")
                .font(.headline)
                .padding(.top, 8)
            
            if viewModel.isLoading {
                HStack {
                    Spacer()
                    ProgressView("Loading episodes...")
                    Spacer()
                }
                .padding()
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
        .alert("Error", isPresented: .constant(viewModel.error != nil), presenting: viewModel.error) { _ in
            Button("OK") { }
        } message: { error in
            Text(error.localizedDescription)
        }
    }
    
    private var emptyEpisodesView: some View {
        HStack {
            Spacer()
            VStack(spacing: 10) {
                Image(systemName: "tv.slash")
                    .font(.largeTitle)
                    .foregroundColor(.secondary)
                Text("No episodes available")
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
            .padding()
            Spacer()
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
                
                Text("Ep. \(episode.number)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(width: 50, alignment: .leading)
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
                // No image URL at all
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
    }
}

#Preview {
    SeasonEpisodesView(seasonId: 1)
        .padding()
}
