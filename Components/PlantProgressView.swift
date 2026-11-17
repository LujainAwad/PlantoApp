
//
// PlantProgressView.swift - Displays daily watering progress.
//
// Contains:
// - Dynamic progress message.
// - Completed reminders count.
// - Animated progress bar.
// - Progress values between 0 and 1.
//
// Used by: HomeView.
//
// Learn: struct, View, computed properties,
// GeometryReader, animation, conditional expressions.
//

import SwiftUI

// MARK: - Plant Progress View

struct PlantProgressView: View {

    // MARK: - Properties

    let completedCount: Int
    let totalCount: Int

    // MARK: - Computed Properties

    private var progress: Double {
        guard totalCount > 0 else {
            return 0
        }

        return min(
            max(Double(completedCount) / Double(totalCount), 0),
            1
        )
    }

    private var progressMessage: String {
        if completedCount == 0 {
            return "Your plants are waiting for a sip 💦"
        } else {
            return "\(completedCount) of your plants feel loved today ✨"
        }
    }

    // MARK: - Body

    var body: some View {

        VStack(spacing: 14) {


            // MARK: - Progress Message

            Text(progressMessage)
                .font(AppFonts.progressText)
                .tracking(AppFonts.Tracking.banner)
                .foregroundStyle(AppColors.primaryText)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)

            // MARK: - Progress Bar

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.progressTrack)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.primaryGreen)
                        .frame(width: geometry.size.width * progress)
                }
            }
            .frame(height: 8)
            .animation(.easeInOut(duration: 0.3), value: progress)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Watering progress")
            .accessibilityValue(
                "\(completedCount) of \(totalCount) completed"
            )
        }
    }
}

// MARK: - Preview

#Preview("Plant Progress") {

    VStack(spacing: 48) {

        PlantProgressView(
            completedCount: 0,
            totalCount: 4
        )

        PlantProgressView(
            completedCount: 1,
            totalCount: 4
        )

        PlantProgressView(
            completedCount: 3,
            totalCount: 4
        )
    }
    .padding(.horizontal, 16)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(AppColors.background)
    .preferredColorScheme(.dark)
}
