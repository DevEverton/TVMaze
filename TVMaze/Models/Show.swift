import Foundation
 
struct Show: Identifiable, Decodable {
    let id: Int
    let name: String
    let image: ImageResponse?
    let summary: String
} 