import Foundation

struct Season: Identifiable, Decodable {
    let id: Int
    let number: Int
    let name: String?
    let episodeOrder: Int?
    let premiereDate: String?
    let endDate: String?
    let summary: String?
    
    enum CodingKeys: String, CodingKey {
        case id, number, name, episodeOrder, premiereDate, endDate, summary
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        number = try container.decode(Int.self, forKey: .number)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        episodeOrder = try container.decodeIfPresent(Int.self, forKey: .episodeOrder)
        premiereDate = try container.decodeIfPresent(String.self, forKey: .premiereDate)
        endDate = try container.decodeIfPresent(String.self, forKey: .endDate)
        
        let rawSummary = try container.decodeIfPresent(String.self, forKey: .summary)
        summary = rawSummary?.strippedHTML
    }
} 
