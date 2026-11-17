
import SwiftUI

// MARK: - App Colors

enum AppColors {

    // MARK: - Backgrounds

    static let background = Color(plantoHex: 0x000000)
    static let sheetBackground = Color(plantoHex: 0x1C1C1E)
    static let formBackground = sheetBackground
    static let cardBackground = Color(plantoHex: 0x2C2C2E)
    static let surface = cardBackground

    static let badgeBackground = Color(plantoHex: 0x18181D)
    static let secondarySurface = Color(plantoHex: 0x222224)
    static let chipBackground = Color(plantoHex: 0x414144)
    static let progressTrack = Color(plantoHex: 0x262626)
    static let trackBackground = progressTrack
    static let scrim = Color(plantoHex: 0x000000).opacity(0.36)

    static let completionCircleBackground =
        Color(plantoHex: 0x14141A).opacity(0.58)

    // MARK: - Dividers & Borders

    static let divider = Color(plantoHex: 0x181819)
    static let headerDivider = Color(plantoHex: 0x39393B)
    static let rowDivider = Color(plantoHex: 0x222224)
    static let fieldDivider = Color(plantoHex: 0x414144)
    static let subtleBorder = Color(plantoHex: 0x979797)

    // MARK: - Green Colors

    static let primaryGreen = Color(plantoHex: 0x338069)
    static let progressGreen = primaryGreen
    static let successGreen = Color(plantoHex: 0x28E0A8)
    static let checkGreen = successGreen
    static let cursorMint = Color(plantoHex: 0x29DFA8)

    static let illustrationGreen = Color(plantoHex: 0x26C391)
    static let leafGreen = Color(plantoHex: 0xCEDE89)
    static let oliveGreen = Color(plantoHex: 0xCCC785)

    // MARK: - Destructive

    static let destructive = Color(plantoHex: 0xFF453A)

    // MARK: - Text

    static let primaryText = Color(plantoHex: 0xFFFFFF)
    static let secondaryText = Color(plantoHex: 0x8E8E93)
    static let fieldValueText = secondaryText
    static let tertiaryText = primaryText.opacity(0.50)

    static let placeholderText = Color(plantoHex: 0x666666)
    static let subtleText = Color(plantoHex: 0x989898)
    static let completedText = Color(plantoHex: 0x666666)

    static let emptyDescriptionText = Color(plantoHex: 0x9F9F91)
    static let emptyReminderText = Color(plantoHex: 0x756F6F)
    static let celebrationText = Color(plantoHex: 0xEAEAD7)

    // MARK: - Supporting Colors

    static let lightLabel =
        Color(plantoHex: 0xCCC785).opacity(0.68)

    static let lightYellow = Color(plantoHex: 0xCCC785)
    static let waterBlue = Color(plantoHex: 0xCAF3FB)
    static let alternateWaterBlue = Color(plantoHex: 0x005EF3)

    static let purpleAccent = Color(plantoHex: 0x624DE6)
    static let documentPurple = Color(plantoHex: 0x7F81FF)

    // MARK: - Illustration Colors

    static let terracotta = Color(plantoHex: 0xEC7047)
    static let peach = Color(plantoHex: 0xFACCB8)
    static let peachMid = Color(plantoHex: 0xF7B192)
    static let coral = Color(plantoHex: 0xF29171)
    static let coralDeep = Color(plantoHex: 0xF08561)
    static let potBrown = Color(plantoHex: 0x41110F)
}

// MARK: - Compatibility

typealias PlantColors = AppColors

// MARK: - HEX Color Initializer

private extension Color {

    init(plantoHex hex: UInt32, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}
