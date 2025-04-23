import Foundation

struct ShowDetails: Identifiable, Decodable {
    let id: Int
    let name: String
    let schedule: Schedule
    let genres: [String]
    let image: ImageResponse?
    let summary: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, schedule, genres, image, summary
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        schedule = try container.decode(Schedule.self, forKey: .schedule)
        genres = try container.decode([String].self, forKey: .genres)
        image = try container.decodeIfPresent(ImageResponse.self, forKey: .image)
        
        let rawSummary = try container.decode(String.self, forKey: .summary)
        summary = rawSummary.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
} 