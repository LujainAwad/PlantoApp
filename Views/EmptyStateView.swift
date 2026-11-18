
import SwiftUI

struct EmptyStateView: View {

    let onAddPlant: () -> Void

    var body: some View {
        VStack(spacing: 0) {

            Spacer()

            Image("plant_empty")
                .resizable()
                .scaledToFit()
                .frame(width: 230, height: 230)

            Text("Start your plant journey!")
                .font(.system(size: 25, weight: .bold))
                .foregroundStyle(AppColors.primaryText)
                .padding(.top, 28)

            Text("Now all your plants will be in one place and we will help you take care of them :) 🪴")
                .font(.system(size: 16))
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .padding(.top, 24)

            Spacer()

            PrimaryTextButton(
                title: "Set Plant Reminder",
                action: onAddPlant
            )
            .padding(.horizontal, 40)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
    }
}

#Preview {
    EmptyStateView(onAddPlant: {})
}
