
import SwiftUI

struct WateringCheckbox: View {

    let isCompleted: Bool
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            ZStack {
                if isCompleted {
                    Circle()
                        .fill(AppColors.successGreen)

                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(AppColors.background)

                } else {
                    Circle()
                        .strokeBorder(
                            AppColors.subtleBorder,
                            lineWidth: 1.2
                        )
                }
            }
            .frame(width: 23, height: 23)
            .frame(width: 44, height: 44)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    WateringCheckbox(isCompleted: true, onToggle: {})
}
