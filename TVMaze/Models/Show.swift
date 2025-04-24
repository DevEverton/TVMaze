import Foundation
 
struct Show: Identifiable, Decodable {
    let id: Int
    let name: String
    let image: ImageResponse?
    let summary: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, image, summary
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        image = try container.decodeIfPresent(ImageResponse.self, forKey: .image)
        
        let rawSummary = try container.decodeIfPresent(String.self, forKey: .summary)
        summary = rawSummary?.strippedHTML ?? "No description available"
    }
} 