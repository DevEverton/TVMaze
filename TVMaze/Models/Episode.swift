import Foundation
 
struct Episode: Decodable {
    let id: Int
    let name: String
    let season: Int
    let number: Int
    let summary: String
    let image: ImageResponse?
}
