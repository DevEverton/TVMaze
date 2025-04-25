import SwiftUI

struct ShowDetailView: View {
    @StateObject private var viewModel: ShowDetailViewModel
    @State private var selectedSeasonId: Int?
    
    init(showId: Int) {
        _viewModel = StateObject(wrappedValue: ShowDetailViewModel(showId: showId))
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 20) {
                showHeader
                
                if let showDetails = viewModel.showDetails {
                    scheduleSection(showDetails: showDetails)
                    
                    if let genres = showDetails.genres, !genres.isEmpty {
                        genresView(genres: genres)
                    }
                    
                    summaryView(summary: showDetails.summary)
                    
                    if !viewModel.seasons.isEmpty {
                        seasonsSection
                    }
                }
            }
            .padding()
        }
        .navigationTitle(viewModel.showDetails?.name ?? "Show Details")
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            if viewModel.isLoading {
                ProgressView("Loading details...")
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
                await viewModel.loadShowDetails()
                if let firstSeason = viewModel.seasons.first {
                    selectedSeasonId = firstSeason.id
                }
            }
        }
    }
    
    private var showHeader: some View {
        HStack(alignment: .top, spacing: 16) {
            if let imageUrl = viewModel.showDetails?.image?.original {
                AsyncImage(url: URL(string: imageUrl)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 225)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 225)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    case .empty:
                        ProgressView()
                            .frame(width: 150, height: 225)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    default:
                        PlaceholderImageView(systemName: "tv", height: 225, backgroundColor: .gray.opacity(0.2), iconColor: .gray)
                    }
                }
            } else {
                PlaceholderImageView(systemName: "tv", height: 225, backgroundColor: .gray.opacity(0.2), iconColor: .gray)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                if let name = viewModel.showDetails?.name {
                    Text(name)
                        .font(.title)
                        .fontWeight(.bold)
                        .lineLimit(2)
                }
                
                if let showDetails = viewModel.showDetails, let status = showDetails.status {
                    HStack {
                        Image(systemName: status.lowercased() == "running" ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(status.lowercased() == "running" ? .green : .secondary)
                        Text(status)
                            .font(.subheadline)
                    }
                }
                
                if let rating = viewModel.showDetails?.rating?.average, rating > 0 {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("\(rating, specifier: "%.1f")")
                            .font(.headline)
                    }
                }
                
                Spacer()
            }
            .padding(.top, 5)
            
            Spacer()
        }
    }
    
    private func scheduleSection(showDetails: ShowDetails) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Schedule")
                .font(.headline)
            
            if let schedule = showDetails.schedule,
               !schedule.days.isEmpty {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.blue)
                    
                    Text("\(schedule.days.joined(separator: ", "))")
                        .font(.subheadline)
                    
                    if !schedule.time.isEmpty {
                        Text("at \(schedule.time)")
                            .font(.subheadline)
                    }
                }
            } else {
                Text("No scheduled time")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private func genresView(genres: [String]) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Genres")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(genres, id: \.self) { genre in
                        Text(genre)
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .clipShape(Capsule())
                    }
                }
            }
        }
    }
    
    private func summaryView(summary: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Summary")
                .font(.headline)
            
            if !summary.isEmpty {
                Text(summary)
                    .font(.subheadline)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                Text("No summary available")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var seasonsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Divider()
            
            Text("Seasons")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(viewModel.seasons) { season in
                        Button(action: {
                            selectedSeasonId = season.id
                        }) {
                            Text("Season \(season.number)")
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(selectedSeasonId == season.id 
                                    ? Color.blue
                                    : Color.blue.opacity(0.1))
                                .foregroundColor(selectedSeasonId == season.id
                                    ? .white
                                    : .blue)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
            if let seasonId = selectedSeasonId {
                SeasonEpisodesView(seasonId: seasonId)
                    .id(seasonId)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ShowDetailView(showId: 1)
    }
}
