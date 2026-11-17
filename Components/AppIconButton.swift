import SwiftUI

// MARK: - App Icon Button

struct AppIconButton: View {

    enum Variant {
        case primary
        case secondary
    }

    let icon: String
    let accessibilityLabel: String
    var variant: Variant = .primary
    var isDisabled = false
    let action: () -> Void

    var body: some View {
        Group {
            if #available(iOS 26.0, *) {
                switch variant {
                case .primary:
                    Button(action: action) {
                        buttonIcon
                    }
                    .buttonStyle(.glassProminent)
                    .buttonBorderShape(.circle)
                    .tint(AppColors.primaryGreen)

                case .secondary:
                    Button(action: action) {
                        buttonIcon
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
                }
            } else {
                Button(action: action) {
                    buttonIcon
                        .foregroundStyle(.white)
                        .background(
                            buttonColor,
                            in: Circle()
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .disabled(isDisabled)
        .accessibilityLabel(accessibilityLabel)
    }

    // MARK: - Icon

    private var buttonIcon: some View {
        Image(systemName: icon)
            .font(.system(
                size: iconSize,
                weight: .medium
            ))
            .frame(width: 44, height: 44)
    }

    // MARK: - Styling

    private var iconSize: CGFloat {
        switch variant {
        case .primary: return 20
        case .secondary: return 17
        }
    }

    private var buttonColor: Color {
        switch variant {
        case .primary:
            return AppColors.primaryGreen
        case .secondary:
            return Color.white.opacity(0.12)
        }
    }
}
