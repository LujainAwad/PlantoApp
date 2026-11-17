
//
// PlantInfoBadge.swift - Reusable plant information badge.
//
// Contains:
// - Icon and text.
// - Light and water badge styles.
// - Completed reminder appearance.
// - Measurements based on Sketch.
//
// Used by: PlantRowView.
//
// Learn: Reusable components, enum, HStack,
// SF Symbols, conditional styling and layout.
//

import SwiftUI

// MARK: - Plant Info Badge

struct PlantInfoBadge: View {

    // MARK: - Badge Type

    enum BadgeType {
        case light
        case water
    }

    // MARK: - Properties

    let title: String
    let type: BadgeType
    let isCompleted: Bool

    // MARK: - Computed Properties

    private var icon: String {
        switch type {
        case .light:
            return "sun.max"
        case .water:
            return "drop"
        }
    }

    private var badgeFont: Font {
        switch type {
        case .light:
            return AppFonts.chipLight
        case .water:
            return AppFonts.chipWater
        }
    }

    private var badgeColor: Color {
        if isCompleted {
            return AppColors.completedText
        }

        switch type {
        case .light:
            return AppColors.lightYellow
        case .water:
            return AppColors.waterBlue
        }
    }

    // MARK: - Body

    var body: some View {

        HStack(spacing: 5) {

            Image(systemName: icon)
                .font(.system(size: 14))

            Text(title)
                .font(badgeFont)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
        }
        .foregroundStyle(badgeColor)
        .padding(.horizontal, 8)
        .frame(height: 23)
        .background(
            AppColors.badgeBackground,
            in: RoundedRectangle(cornerRadius: 8)
        )
    }
}

// MARK: - Previews

#Preview("Plant Info Badges") {

    VStack(spacing: 20) {

        HStack(spacing: 8) {

            PlantInfoBadge(
                title: "Full sun",
                type: .light,
                isCompleted: false
            )

            PlantInfoBadge(
                title: "20-50 ml",
                type: .water,
                isCompleted: false
            )
        }

        HStack(spacing: 8) {

            PlantInfoBadge(
                title: "Full sun",
                type: .light,
                isCompleted: true
            )

            PlantInfoBadge(
                title: "20-50 ml",
                type: .water,
                isCompleted: true
            )
        }
    }
    .padding()
    .background(AppColors.background)
    .preferredColorScheme(.dark)
}
