
import SwiftUI

struct PlantFormRow: View {

    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: 8) {

            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(AppColors.primaryText)
                .frame(width: 24)

            Text(title)
                .font(AppFonts.formLabel)
                .foregroundStyle(AppColors.primaryText)

            Spacer()

            Text(value)
                .font(AppFonts.fieldValue)
                .foregroundStyle(AppColors.secondaryText)
                .lineLimit(1)

            Image(systemName: "chevron.up.chevron.down")
                .font(.system(size: 11))
                .foregroundStyle(AppColors.secondaryText)
        }
        .padding(.horizontal, 16)
        .frame(minHeight: 52)
    }
}

#Preview {
    PlantFormRow(
        icon: "location",
        title: "Room",
        value: "Bedroom"
    )
}
