
import SwiftUI

struct HomeView: View {

    @State private var viewModel = PlantViewModel()
    @State private var showSheet = false
    @State private var editingPlant: Plant?

    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        VStack(spacing: 0) {

            // Header
            HStack {
                Text("My Plants 🌱")
                    .font(AppFonts.screenTitle)
                    .foregroundStyle(AppColors.primaryText)

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 32)
            .padding(.bottom, 24)

            Rectangle()
                .fill(AppColors.headerDivider)
                .frame(height: 1)

            // Screen Content
            switch viewModel.screenState {

            case .empty:
                EmptyStateView {
                    editingPlant = nil
                    showSheet = true
                }

            case .noReminders:
                VStack {
                    Spacer()

                    Text("No reminders set yet...")
                        .font(AppFonts.emptyTitle)
                        .foregroundStyle(AppColors.emptyReminderText)

                    Spacer()
                }
                .frame(maxWidth: .infinity)

            case .todayReminders:
                todayRemindersView

            case .allDone:
                AllDoneView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background.ignoresSafeArea())

        // Add Button
        .overlay(alignment: .bottomTrailing) {
            if viewModel.screenState != .empty {
                AppIconButton(
                    icon: "plus",
                    accessibilityLabel: "Add plant"
                ) {
                    editingPlant = nil
                    showSheet = true
                }
                .padding(20)
            }
        }

        // Add or Edit
        .sheet(isPresented: $showSheet) {
            SetReminderView(
                viewModel: viewModel,
                editingPlant: editingPlant
            )
            .presentationDetents([.large])
        }

        // Refresh
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                viewModel.refreshDailyReminders()
            }
        }
    }

    // Plant List
    private var todayRemindersView: some View {
        List {

            PlantProgressView(
                completedCount: viewModel.completedCount,
                totalCount: viewModel.totalCount
            )
            .padding(.vertical, 30)
            .listRowBackground(AppColors.background)
            .listRowSeparator(.hidden)

            ForEach(viewModel.todayReminders) { plant in
                PlantRowView(
                    plant: plant,
                    isCompleted: viewModel.isCompleted(plant),
                    onToggle: {
                        viewModel.toggleReminder(for: plant)
                    },
                    onEdit: {
                        editingPlant = plant
                        showSheet = true
                    }
                )
                .listRowInsets(EdgeInsets())
                .listRowBackground(AppColors.background)
                .listRowSeparator(.hidden)
                .swipeActions {
                    Button(role: .destructive) {
                        viewModel.deletePlant(plant)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .safeAreaPadding(.bottom, 80)
    }
}

#Preview {
    HomeView()
}
