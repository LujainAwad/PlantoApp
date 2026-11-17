//PlantFormRow.swift - Reusable row for plant settings.
//
// Contains:
// - Setting icon and title.
// - Currently selected value.
// - Dropdown indicator.
// - Consistent layout using the Planto Design System.
//
// Used by: SetReminderView, PlantFormCard.
//
// Learn: struct, View, HStack, Spacer, parameters,
// reusable components, accessibility.
//
// Note:
// - This component displays content only.
// - Picker/Menu interaction is handled by SetReminderView.
// - Liquid Glass is applied to suitable interactive controls.
//

import SwiftUI

// MARK: - Plant Form Row

struct PlantFormRow: View {

    // MARK: - Properties

    let icon: String
    let title: String
    let value: String

    // MARK: - Body

    var body: some View {

        HStack(spacing: 8) {

            // MARK: - Icon

            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(AppColors.primaryText)
                .frame(width: 24)

            // MARK: - Title

            Text(title)
                .font(AppFonts.formLabel)
                .tracking(AppFonts.Tracking.formRow)
                .foregroundStyle(AppColors.primaryText)

            Spacer(minLength: 8)


            // MARK: - Selected Value

            Text(value)
                .font(AppFonts.fieldValue)
                .tracking(AppFonts.Tracking.formRow)
                .foregroundStyle(AppColors.secondaryText)
                .lineLimit(1)
                .multilineTextAlignment(.trailing)


            // MARK: - Dropdown Indicator

            Image(systemName: "chevron.up.chevron.down")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(AppColors.secondaryText)
        }
        .padding(.horizontal, 16)
        .frame(minHeight: 52)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title), \(value)")
    }
}

// MARK: - Preview

#Preview("Plant Form Rows") {

    VStack(spacing: 0) {

        PlantFormRow(
            icon: "location",
            title: "Room",
            value: "Bedroom"
        )

        Divider()
            .overlay(AppColors.fieldDivider)

        PlantFormRow(
            icon: "sun.max",
            title: "Light",
            value: "Full Sun"
        )
    }
    .background(AppColors.cardBackground)
    .clipShape(RoundedRectangle(cornerRadius: 30))
    .padding(16)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(AppColors.sheetBackground)
    .preferredColorScheme(.dark)
}
