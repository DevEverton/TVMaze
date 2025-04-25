import SwiftUI

struct EpisodeDetailView: View {
    @StateObject private var viewModel: EpisodeDetailViewModel
    
    init(episodeId: Int) {
        _viewModel = StateObject(wrappedValue: EpisodeDetailViewModel(episodeId: episodeId))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imageUrl = viewModel.episode?.image?.original {
                    AsyncImage(url: URL(string: imageUrl)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 220)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        case .failure:
                            PlaceholderImageView(
                                systemName: "tv.slash",
                                height: 220,
                                backgroundColor: Color.gray.opacity(0.1),
                                iconColor: .gray
                            )
                        case .empty:
                            ProgressView()
                                .frame(height: 220)
                                .frame(maxWidth: .infinity)
                        default:
                            PlaceholderImageView(
                                systemName: "tv.slash",
                                height: 220,
                                backgroundColor: Color.gray.opacity(0.1),
                                iconColor: .gray
                            )
                        }
                    }
                } else {
                    PlaceholderImageView(
                        systemName: "tv.slash",
                        height: 220,
                        backgroundColor: Color.gray.opacity(0.1),
                        iconColor: .gray
                    )
                }
                
                if let episode = viewModel.episode {
                    VStack(alignment: .leading, spacing: 16) {
                        episodeHeaderView(episode: episode)
                        
                        if !episode.summary.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Summary")
                                    .font(.headline)
                                
                                Text(episode.summary)
                                    .font(.body)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        
                        Spacer()
                    }
                    
                }
            }

        }
        .padding(.horizontal)
        .navigationTitle(viewModel.episode?.name ?? "Episode Details")
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            if viewModel.isLoading {
                ProgressView("Loading episode details...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.ultraThinMaterial)
            }
        }
        .alert("Error", isPresented: .constant(viewModel.error != nil), presenting: viewModel.error) { _ in
            Button("OK") { }
        } message: { error in
            Text(error.localizedDescription)
        }
        .onAppear {
            Task {
                await viewModel.loadEpisodeDetails()
            }
        }
    }
    
    private func episodeHeaderView(episode: Episode) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(episode.name)
                .font(.title)
                .fontWeight(.bold)
            
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Image(systemName: "tv")
                        .foregroundColor(.blue)
                    Text("Season \(episode.season)")
                        .fontWeight(.medium)
                }
                
                if let number = episode.number {
                    HStack(spacing: 4) {
                        Image(systemName: "play.circle")
                            .foregroundColor(.blue)
                        Text("Episode \(number)")
                            .fontWeight(.medium)
                    }
                } else {
                    HStack(spacing: 4) {
                        Image(systemName: "star")
                            .foregroundColor(.yellow)
                        Text("Special")
                            .fontWeight(.medium)
                    }
                }
            }
            .font(.subheadline)
            .padding(.bottom, 8)
        }
    }
}
