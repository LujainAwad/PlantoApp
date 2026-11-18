
import SwiftUI

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
            if variant == .primary {
                Button(action: action) {
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.glassProminent)
                .tint(AppColors.primaryGreen)

            } else {
                Button(action: action) {
                    Image(systemName: icon)
                        .font(.system(size: 17))
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.glass)
            }
        }
        .buttonBorderShape(.circle)
        .disabled(isDisabled)
        .accessibilityLabel(accessibilityLabel)
    }
}

#Preview {
    AppIconButton(
        icon: "plus",
        accessibilityLabel: "Add"
    ) { }
}
