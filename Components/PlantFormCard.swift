//PlantFormCard.swift - Reusable container for plant form rows.
//
// Contains:
// - Rounded card background.
// - Two configurable form rows.
// - Divider between the rows.
// - Consistent card styling.
//
// Used by: SetReminderView.
//
// Learn: generic views, @ViewBuilder, VStack,
// reusable containers, and corner radius.
//
// Note:
// - Radius and divider styling belong to this component.
// - Picker/Menu interactions are handled by SetReminderView.
// - Liquid Glass is not applied to form card backgrounds.
//

import SwiftUI

// MARK: - Plant Form Card

struct PlantFormCard<FirstRow: View, SecondRow: View>: View {

    // MARK: - Properties

    let firstRow: FirstRow
    let secondRow: SecondRow

    // MARK: - Initializer

    init(
        @ViewBuilder firstRow: () -> FirstRow,
        @ViewBuilder secondRow: () -> SecondRow
    ) {
        self.firstRow = firstRow()
        self.secondRow = secondRow()
    }

    // MARK: - Body

    var body: some View {

        VStack(spacing: 0) {

            firstRow

            // Divider between the two rows
            Rectangle()
                .fill(AppColors.fieldDivider)
                .frame(height: 1)
                .padding(.horizontal, 16)

            secondRow
        }
        .background(
            AppColors.cardBackground,
            in: RoundedRectangle(cornerRadius: 30)
        )
    }
}

// MARK: - Preview

#Preview("Plant Form Cards") {

    VStack(spacing: 48) {

        // MARK: - Room & Light

        PlantFormCard {

            PlantFormRow(
                icon: "location",
                title: "Room",
                value: "Bedroom"
            )

        } secondRow: {

            PlantFormRow(
                icon: "sun.max",
                title: "Light",
                value: "Full Sun"
            )
        }

        // MARK: - Watering Days & Water

        PlantFormCard {

            PlantFormRow(
                icon: "drop",
                title: "Watering Days",
                value: "Every day"
            )

        } secondRow: {

            PlantFormRow(
                icon: "drop",
                title: "Water",
                value: "20-50 ml"
            )
        }
    }
    .padding(.horizontal, 16)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(AppColors.sheetBackground)
    .preferredColorScheme(.dark)
}
