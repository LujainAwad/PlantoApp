
import SwiftUI

struct PrimaryTextButton: View {
    let title: String
    let action: () -> Void
    var isDisabled = false

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
        }
        .buttonStyle(.glassProminent)
        .buttonBorderShape(.capsule)
        .tint(AppColors.primaryGreen)
        .disabled(isDisabled)
    }
}

#Preview("Primary Button") {
    PrimaryTextButton(title: "Set Plant Reminder") { }
        .padding(40)
       
}
