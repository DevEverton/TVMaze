import SwiftUI

struct PlaceholderImageView: View {
    var systemName: String
    var height: CGFloat
    var backgroundColor: Color
    var iconColor: Color
    
    init(
        systemName: String = "tv",
        height: CGFloat = 150,
        backgroundColor: Color = Color.gray.opacity(0.1),
        iconColor: Color = .gray
    ) {
        self.systemName = systemName
        self.height = height
        self.backgroundColor = backgroundColor
        self.iconColor = iconColor
    }
    
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: systemName)
                .font(.system(size: height * 0.25))
                .foregroundColor(iconColor)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}