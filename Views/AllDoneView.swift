
//
// AllDoneView.swift - Displays the completion state.
//
// Contains:
// - Completed plant illustration.
// - Oval background behind the plant.
// - All Done celebration message.
// - Confirmation that all reminders are complete.
//
// Used by: HomeView.
//
// Learn: struct, View, VStack, ZStack,
// Image, Spacer, and reusable design system.
//
// Note:
// - Header and add button belong to HomeView.
// - No Liquid Glass is needed for static content.
//

import SwiftUI

// MARK: - All Done View

struct AllDoneView: View {

    // MARK: - Body

    var body: some View {

        VStack(spacing: 0) {

            Spacer()

            // MARK: - Completed Plant Illustration

            ZStack {

                // Oval background from Sketch
                Ellipse()
                    .fill(AppColors.completionCircleBackground)
                    .frame(width: 219, height: 227)

                // Completed plant image
                Image("plant_completed")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 164)
            }
            .frame(width: 219, height: 227)

            // MARK: - Completion Title

            Text("All Done! 🎉")
                .font(AppFonts.stateTitle)
                .foregroundStyle(AppColors.primaryText)
                .padding(.top, 33)

            // MARK: - Completion Description

            Text("All Reminders Completed")
                .font(AppFonts.description)
                .foregroundStyle(AppColors.completedText)
                .padding(.top, 14)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
    }
}

// MARK: - Preview

#Preview("All Done") {
    AllDoneView()
        .preferredColorScheme(.dark)
}
