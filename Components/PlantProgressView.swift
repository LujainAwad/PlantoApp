
import SwiftUI

struct PlantProgressView: View {

    let completedCount: Int
    let totalCount: Int

    var progress: Double {
        if totalCount == 0 {
            return 0
        }

        return Double(completedCount) / Double(totalCount)
    }

    var body: some View {
        VStack(spacing: 14) {

            // Progress Message
            if completedCount == 0 {
                Text("Your plants are waiting for a sip 💦")
                    .font(AppFonts.progressText)
            } else {
                Text("\(completedCount) of your plants feel loved today ✨")
                    .font(AppFonts.progressText)
            }

            // Custom Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {

                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.progressTrack)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.primaryGreen)
                        .frame(width: geometry.size.width * progress)
                }
            }
            .frame(height: 8)
            .animation(.easeInOut(duration: 0.3), value: progress)
        }
        .frame(maxWidth: .infinity)
        .foregroundStyle(AppColors.primaryText)
    }
}

#Preview {
    PlantProgressView(
        completedCount: 2,
        totalCount: 4
    )
    .padding()
}
