
//
// WateringCheckbox.swift
// Reusable watering completion control.
//
// Contains:
// - Completed and incomplete states.
// - Circular checkbox appearance.
// - Tap action.
//
// Used by: PlantRowView.
//
// Learn: Button, Bool, if-else,
// ZStack, closures, and reusable components.
//

import SwiftUI

// MARK: - Watering Checkbox

struct WateringCheckbox: View {

    // MARK: - Properties

    let isCompleted: Bool
    let onToggle: () -> Void

    // MARK: - Body

    var body: some View {

        Button(action: onToggle) {

            ZStack {

                if isCompleted {

                    // MARK: - Completed State

                    Circle()
                        .fill(AppColors.successGreen)

                    Image(systemName: "checkmark")
                        .font(
                            .system(
                                size: 12,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(AppColors.background)

                } else {

                    // MARK: - Incomplete State

                    Circle()
                        .strokeBorder(
                            AppColors.subtleBorder,
                            lineWidth: 1.2
                        )
                }
            }
            .frame(width: 23, height: 23)
            .frame(width: 44, height: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Previews

#Preview("Not Completed") {

    ZStack {

        AppColors.background.ignoresSafeArea()

        WateringCheckbox(
            isCompleted: false,
            onToggle: {}
        )
    }
    .preferredColorScheme(.dark)
}

#Preview("Completed") {

    ZStack {

        AppColors.background.ignoresSafeArea()

        WateringCheckbox(
            isCompleted: true,
            onToggle: {}
        )
    }
    .preferredColorScheme(.dark)
}
