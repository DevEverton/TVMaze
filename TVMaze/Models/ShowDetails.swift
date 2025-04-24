import Foundation

struct ShowDetails: Identifiable, Decodable {
    let id: Int
    let name: String
    let schedule: Schedule
    let genres: [String]
    let image: ImageResponse?
    let summary: String
} 
