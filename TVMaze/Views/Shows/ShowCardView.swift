import SwiftUI

struct ShowCardView: View {
    let show: Show

    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            AsyncImage(url: URL(string: show.image?.medium ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 120)
                        .clipped()
                        .cornerRadius(8)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 120)
                        .foregroundColor(.gray)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                case .empty:
                    ProgressView()
                        .frame(width: 80, height: 120)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                default:
                    EmptyView()
                }
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(show.name)
                    .font(.headline)
                
                Text(show.summary.strippedHTML)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                
                
                Spacer()
            }
            .padding(.vertical, 5)

            Spacer()
        }
        .padding(.vertical, 5)
    }
}
