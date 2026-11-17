
//
// EmptyStateView.swift - Displays the empty plant state.
//
// Contains:
// - Plant illustration.
// - Welcome title and description.
// - Reusable PrimaryTextButton.
//
// Used by: HomeView.
//
// Learn: VStack, Spacer, Image, Text,
// reusable components, and closures.
//

import SwiftUI

// MARK: - Empty State View

struct EmptyStateView: View {

    // MARK: - Properties

    let onAddPlant: () -> Void

    // MARK: - Body

    var body: some View {

        VStack(spacing: 0) {

            Spacer()

            // MARK: - Plant Illustration

            Image("plant_empty")
                .resizable()
                .scaledToFit()
                .frame(width: 230, height: 230)

            // MARK: - Welcome Title

            Text("Start your plant journey!")
                .font(.system(size: 25, weight: .bold))
                .foregroundStyle(AppColors.primaryText)
                .padding(.top, 28)

            // MARK: - Description

            Text(
                "Now all your plants will be in one place and we will help you take care of them :) 🪴"
            )
            .font(.system(size: 16))
            .foregroundStyle(.gray)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 30)
            .padding(.top, 24)

            Spacer()

            // MARK: - Add Reminder Button

            PrimaryTextButton(
                title: "Set Plant Reminder",
                action: onAddPlant
            )
            .padding(.horizontal, 40)

            Spacer()
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .background(AppColors.background)
    }
}

// MARK: - Preview

#Preview("Empty State") {

    EmptyStateView(onAddPlant: {})
        .preferredColorScheme(.dark)
}
