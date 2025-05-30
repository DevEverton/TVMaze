import Foundation
 
struct Episode: Identifiable, Decodable, Equatable {
    let id: Int
    let name: String
    let season: Int
    let number: Int?
    let summary: String
    let image: ImageResponse?

    enum CodingKeys: String, CodingKey {
        case id, name, season, number, summary, image
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self) 
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        season = try container.decode(Int.self, forKey: .season)
        number = try container.decodeIfPresent(Int.self, forKey: .number)
        image = try container.decodeIfPresent(ImageResponse.self, forKey: .image)
        
        let rawSummary = try container.decodeIfPresent(String.self, forKey: .summary)
        summary = rawSummary?.strippedHTML ?? "No description available"
    }

    static func == (lhs: Episode, rhs: Episode) -> Bool {
        return lhs.id == rhs.id
    }
}
