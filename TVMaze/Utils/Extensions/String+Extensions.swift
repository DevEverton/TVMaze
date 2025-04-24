import Foundation

extension String {
    var strippedHTML: String {
        return replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
} 