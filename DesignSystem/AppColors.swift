
import SwiftUI

enum AppColors {

    // Backgrounds
    static let background = Color(plantoHex: 0x000000)
    static let sheetBackground = Color(plantoHex: 0x1C1C1E)
    static let cardBackground = Color(plantoHex: 0x2C2C2E)
    static let badgeBackground = Color(plantoHex: 0x18181D)
    static let progressTrack = Color(plantoHex: 0x262626)
    static let completionCircleBackground = Color(plantoHex: 0x14141A).opacity(0.58)

    // Dividers
    static let headerDivider = Color(plantoHex: 0x39393B)
    static let rowDivider = Color(plantoHex: 0x222224)
    static let fieldDivider = Color(plantoHex: 0x414144)
    static let subtleBorder = Color(plantoHex: 0x979797)

    // Main Colors
    static let primaryGreen = Color(plantoHex: 0x338069)
    static let successGreen = Color(plantoHex: 0x28E0A8)
    static let cursorMint = Color(plantoHex: 0x29DFA8)
    static let destructive = Color(plantoHex: 0xFF453A)

    // Text Colors
    static let primaryText = Color(plantoHex: 0xFFFFFF)
    static let secondaryText = Color(plantoHex: 0x8E8E93)
    static let tertiaryText = Color.white.opacity(0.50)
    static let completedText = Color(plantoHex: 0x666666)
    static let emptyReminderText = Color(plantoHex: 0x756F6F)

    // Plant Information
    static let lightYellow = Color(plantoHex: 0xCCC785)
    static let waterBlue = Color(plantoHex: 0xCAF3FB)
}

// Convert HEX to Color
private extension Color {
    init(plantoHex hex: UInt32) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: 1
        )
    }
}
