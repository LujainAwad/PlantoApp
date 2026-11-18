
import SwiftUI

struct AllDoneView: View {

    var body: some View {
        VStack(spacing: 0) {

            Spacer()

            ZStack {
                Ellipse()
                    .fill(AppColors.completionCircleBackground)
                    .frame(width: 219, height: 227)

                Image("plant_completed")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 164)
            }

            Text("All Done! 🎉")
                .font(AppFonts.stateTitle)
                .foregroundStyle(AppColors.primaryText)
                .padding(.top, 33)

            Text("All Reminders Completed")
                .font(AppFonts.description)
                .foregroundStyle(AppColors.completedText)
                .padding(.top, 14)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
    }
}

#Preview {
    AllDoneView()
}
