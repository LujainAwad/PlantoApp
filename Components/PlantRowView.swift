
import SwiftUI

struct PlantRowView: View {

    let plant: Plant
    let isCompleted: Bool
    let onToggle: () -> Void
    let onEdit: () -> Void

    var body: some View {
        HStack(spacing: 16) {

            WateringCheckbox(
                isCompleted: isCompleted,
                onToggle: onToggle
            )

            Button(action: onEdit) {
                VStack(alignment: .leading, spacing: 4) {

                    Label(
                        "in \(plant.room.rawValue)",
                        systemImage: "location"
                    )
                    .font(AppFonts.plantRoom)
                    .foregroundStyle(
                        isCompleted
                        ? AppColors.completedText
                        : AppColors.tertiaryText
                    )

                    Text(plant.name)
                        .font(AppFonts.plantName)
                        .foregroundStyle(
                            isCompleted
                            ? AppColors.completedText
                            : AppColors.primaryText
                        )
                        .lineLimit(1)

                    HStack(spacing: 8) {
                        PlantInfoBadge(
                            title: plant.light.rawValue,
                            type: .light,
                            isCompleted: isCompleted
                        )

                        PlantInfoBadge(
                            title: plant.waterAmount.rawValue,
                            type: .water,
                            isCompleted: isCompleted
                        )
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .frame(minHeight: 98)
        .overlay(alignment: .bottom) {
            AppColors.rowDivider
                .frame(height: 1)
        }
    }
}

#Preview {
    PlantRowView(
        plant: Plant(
            name: "Monstera",
            room: .kitchen,
            light: .fullSun,
            wateringFrequency: .everyDay,
            waterAmount: .small
        ),
        isCompleted: false,
        onToggle: {},
        onEdit: {}
    )
}
