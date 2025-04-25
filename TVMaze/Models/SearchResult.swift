import Foundation

struct SearchResult: Identifiable, Decodable {
    let score: Double
    let show: Show
    
    var id: Int { show.id }
} 