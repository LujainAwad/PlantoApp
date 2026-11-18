
import SwiftUI

struct PlantInfoBadge: View {

    enum BadgeType {
        case light
        case water
    }

    let title: String
    let type: BadgeType
    let isCompleted: Bool

    var body: some View {
        HStack(spacing: 5) {

            Image(systemName: type == .light ? "sun.max" : "drop")
                .font(.system(size: 14))

            Text(title)
                .font(type == .light ? AppFonts.chipLight : AppFonts.chipWater)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
        }
        .foregroundStyle(
            isCompleted
            ? AppColors.completedText
            : (type == .light ? AppColors.lightYellow : AppColors.waterBlue)
        )
        .padding(.horizontal, 8)
        .frame(height: 23)
        .background(
            AppColors.badgeBackground,
            in: RoundedRectangle(cornerRadius: 8)
        )
    }
}

#Preview {
    PlantInfoBadge(
        title: "Full Sun",
        type: .light,
        isCompleted: false
    )
}
