
//
// PrimaryTextButton.swift
// Reusable primary text button.
//
// Contains:
// - Custom button title.
// - Capsule shape.
// - Liquid Glass on iOS 26+.
// - Primary green tint.
// - Enabled and disabled states.
//
// Used by: EmptyStateView.
//
// Learn: Reusable Views, properties,
// closures, and Button styles.
//

import SwiftUI

// MARK: - Primary Text Button

struct PrimaryTextButton: View {

    // MARK: - Properties

    let title: String
    let action: () -> Void

    var isDisabled: Bool = false

    // MARK: - Body

    var body: some View {

        Group {

            if #available(iOS 26.0, *) {

                Button(action: action) {
                    buttonLabel
                }
                .buttonStyle(.glassProminent)
                .buttonBorderShape(.capsule)
                .tint(AppColors.primaryGreen)

            } else {

                Button(action: action) {

                    buttonLabel
                        .background(
                            AppColors.primaryGreen,
                            in: Capsule()
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .disabled(isDisabled)
    }

    // MARK: - Label

    private var buttonLabel: some View {

        Text(title)
            .font(.system(size: 17, weight: .medium))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .contentShape(Capsule())
    }
}

// MARK: - Preview

#Preview("Primary Text Button") {

    ZStack {

        AppColors.background.ignoresSafeArea()

        PrimaryTextButton(
            title: "Set Plant Reminder"
        ) {
            print("Set Reminder tapped")
        }
        .padding(.horizontal, 40)
    }
    .preferredColorScheme(.dark)
}
