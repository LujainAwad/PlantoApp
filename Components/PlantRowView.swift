
//
// PlantRowView.swift - Displays a single plant reminder.
//
// Contains:
// - Plant name and room.
// - Reusable PlantInfoBadge for light and water.
// - Reusable WateringCheckbox.
// - Different appearance for completed reminders.
// - Tap action for editing a plant.
//
// Used by: HomeView.
//
// Learn: HStack, VStack, Button,
// conditional styling and reusable components.
//

import SwiftUI

// MARK: - Plant Row View

struct PlantRowView: View {

    // MARK: - Properties

    let plant: Plant
    let isCompleted: Bool
    let onToggle: () -> Void
    let onEdit: () -> Void

    // MARK: - Body

    var body: some View {

        HStack(spacing: 16) {

            // MARK: - Watering Checkbox

            WateringCheckbox(
                isCompleted: isCompleted,
                onToggle: onToggle
            )

            // MARK: - Plant Information

            Button(action: onEdit) {

                VStack(alignment: .leading, spacing: 4) {

                    // MARK: - Plant Room

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

                    // MARK: - Plant Name

                    Text(plant.name)
                        .font(AppFonts.plantName)
                        .foregroundStyle(
                            isCompleted
                            ? AppColors.completedText
                            : AppColors.primaryText
                        )
                        .lineLimit(1)

                    // MARK: - Information Badges

                    HStack(spacing: 8) {

                        // MARK: - Light Badge

                        PlantInfoBadge(
                            title: plant.light.rawValue,
                            type: .light,
                            isCompleted: isCompleted
                        )

                        // MARK: - Water Badge

                        PlantInfoBadge(
                            title: plant.waterAmount.rawValue,
                            type: .water,
                            isCompleted: isCompleted
                        )
                    }
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Edit \(plant.name)")
        }
        .padding(.horizontal, 16)
        .frame(minHeight: 98)

        // MARK: - Row Divider

        .overlay(alignment: .bottom) {

            AppColors.rowDivider
                .frame(height: 1)
        }
    }
}

// MARK: - Preview

#Preview("Plant Row") {

    let plant = Plant(
        name: "Monstera",
        room: .kitchen,
        light: .fullSun,
        wateringFrequency: .everyDay,
        waterAmount: .small
    )

    VStack(spacing: 0) {

        PlantRowView(
            plant: plant,
            isCompleted: false,
            onToggle: {},
            onEdit: {}
        )

        PlantRowView(
            plant: plant,
            isCompleted: true,
            onToggle: {},
            onEdit: {}
        )
    }
    .background(AppColors.background)
    .preferredColorScheme(.dark)
}
