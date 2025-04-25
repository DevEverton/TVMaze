import Foundation

struct ShowDetails: Identifiable, Decodable {
    let id: Int
    let name: String
    let image: ImageResponse?
    let summary: String
    let genres: [String]?
    let status: String?
    let schedule: Schedule?
    let rating: Rating?
    
    enum CodingKeys: String, CodingKey {
        case id, name, image, summary, genres, status, schedule, rating
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        image = try container.decodeIfPresent(ImageResponse.self, forKey: .image)
        genres = try container.decodeIfPresent([String].self, forKey: .genres)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        schedule = try container.decodeIfPresent(Schedule.self, forKey: .schedule)
        rating = try container.decodeIfPresent(Rating.self, forKey: .rating)
        
        let rawSummary = try container.decodeIfPresent(String.self, forKey: .summary)
        summary = rawSummary?.strippedHTML ?? "No description available"
    }
}

struct Rating: Decodable {
    let average: Double?
} 
