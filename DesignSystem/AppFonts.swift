
import SwiftUI

// MARK: - App Fonts

enum AppFonts {

    // MARK: - Titles

    static let screenTitle: Font =
        .system(size: 34, weight: .bold)

    static let plantName: Font =
        .system(size: 28, weight: .regular)

    static let stateTitle: Font =
        .system(size: 25, weight: .semibold)

    static let emptyTitle: Font =
        .system(size: 20, weight: .semibold)

    // MARK: - Form

    static let formHeader: Font =
        .system(size: 17, weight: .semibold)

    static let formLabel: Font =
        .system(size: 18, weight: .regular)

    static let fieldValue: Font =
        .system(size: 18, weight: .regular)

    // MARK: - Body & Messages

    static let progressText: Font =
        .system(size: 18, weight: .regular)

    static let description: Font =
        .system(size: 16, weight: .regular)

    // MARK: - Plant Information

    static let plantRoom: Font =
        .system(size: 15, weight: .regular)

    static let chipLight: Font =
        .system(size: 14, weight: .regular)

    static let chipWater: Font =
        .system(size: 14, weight: .medium)

    // MARK: - Buttons

    static let destructiveButton: Font =
        .system(size: 16, weight: .regular)

    // MARK: - Character Tracking

    enum Tracking {
        static let banner: CGFloat = 0.234
        static let formRow: CGFloat = -0.455
    }
}
