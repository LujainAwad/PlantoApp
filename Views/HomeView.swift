
//
// HomeView.swift - Main screen of the Planto app.
//
// Contains:
// - My Plants header.
// - Empty, No Reminders, Today, and All Done states.
// - Daily progress and plant reminders.
// - Add and edit plant sheets.
// - Swipe to delete with confirmation.
// - Floating Liquid Glass add button.
// - Daily refresh when the app becomes active.
//
// Used by: PlantoApp.
//
// Learn: @State, @Environment, switch, List,
// ForEach, sheet, confirmationDialog, scenePhase,
// and Feature-Based MVVM.
//

import SwiftUI

// MARK: - Home View

struct HomeView: View {

        @State private var plantViewModel = PlantViewModel()



    // MARK: - UI State

    @State private var activeSheet: PlantSheet?
    @State private var plantToDelete: Plant?
    @State private var showDeleteConfirmation = false

    // MARK: - Environment

    @Environment(\.scenePhase) private var scenePhase


    // MARK: - Sheet Destination

    private enum PlantSheet: Identifiable {

        case add
        case edit(Plant)

        var id: String {

            switch self {

            case .add:
                return "add"

            case .edit(let plant):
                return plant.id.uuidString
            }
        }
    }

    // MARK: - Body

    var body: some View {

        VStack(spacing: 0) {

            header

            // MARK: - Screen State

            Group {

                switch plantViewModel.screenState {

                case .empty:

                    EmptyStateView {
                        activeSheet = .add
                    }

                case .noReminders:

                    noRemindersView

                case .todayReminders:

                    todayRemindersView

                case .allDone:

                    AllDoneView()
                }
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
        }
        .background(
            AppColors.background.ignoresSafeArea()
        )

        // MARK: - Floating Add Button

        .overlay(alignment: .bottomTrailing) {

            if plantViewModel.shouldShowAddButton {

                addButton
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
            }
        }

        // MARK: - Add / Edit Sheet

        .sheet(item: $activeSheet) { destination in

            switch destination {

            case .add:

                SetReminderView(
                    plantStore: plantViewModel
                )
                .presentationDetents([.large])

            case .edit(let plant):

                SetReminderView(
                    plantStore: plantViewModel,
                    editingPlant: plant
                )
                .presentationDetents([.large])
            }
        }

        // MARK: - Delete Confirmation

        .confirmationDialog(
            "Delete Plant Reminder?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {

            Button(
                "Delete Reminder",
                role: .destructive
            ) {

                guard let plant = plantToDelete else {
                    return
                }

                withAnimation {
                    plantViewModel.deletePlant(plant)
                }

                plantToDelete = nil
            }

            Button("Cancel", role: .cancel) {
                plantToDelete = nil
            }

        } message: {

            Text(
                "This plant reminder will be permanently deleted."
            )
        }

        // MARK: - Daily Refresh

        .onChange(of: scenePhase) { _, newPhase in

            if newPhase == .active {
                plantViewModel.refreshDailyReminders()
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Header

    private var header: some View {

        VStack(spacing: 0) {

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
        }
    }

    // MARK: - No Reminders View

    private var noRemindersView: some View {

        VStack {

            Spacer()

            Text("No reminders set yet...")
                .font(AppFonts.emptyTitle)
                .foregroundStyle(
                    AppColors.emptyReminderText
                )

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Today's Reminders

    private var todayRemindersView: some View {

        List {

            // MARK: - Daily Progress

            PlantProgressView(
                completedCount: plantViewModel.completedCount,
                totalCount: plantViewModel.totalCount
            )
            .padding(.horizontal, 8)
            .padding(.top, 36)
            .padding(.bottom, 40)
            .listRowInsets(
                EdgeInsets(
                    top: 0,
                    leading: 16,
                    bottom: 0,
                    trailing: 16
                )
            )
            .listRowBackground(AppColors.background)
            .listRowSeparator(.hidden)

            // MARK: - Plant Rows

            ForEach(plantViewModel.todayReminders) { plant in

                PlantRowView(
                    plant: plant,
                    isCompleted: plantViewModel.isCompleted(plant),

                    onToggle: {

                        withAnimation(
                            .easeInOut(duration: 0.3)
                        ) {
                            plantViewModel.toggleReminder(
                                for: plant
                            )
                        }
                    },

                    onEdit: {
                        activeSheet = .edit(plant)
                    }
                )
                .listRowInsets(
                    EdgeInsets(
                        top: 0,
                        leading: 0,
                        bottom: 0,
                        trailing: 0
                    )
                )
                .listRowBackground(AppColors.background)
                .listRowSeparator(.hidden)

                // MARK: - Swipe to Delete

                .swipeActions(
                    edge: .trailing,
                    allowsFullSwipe: false
                ) {

                    Button(role: .destructive) {

                        plantToDelete = plant
                        showDeleteConfirmation = true

                    } label: {

                        Label(
                            "Delete",
                            systemImage: "trash"
                        )
                    }
                    .tint(AppColors.destructive)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(AppColors.background)
        .contentMargins(
            .bottom,
            100,
            for: .scrollContent
        )
    }


    // MARK: - Floating Add Button

    private var addButton: some View {
        AppIconButton(
            icon: "plus",
            accessibilityLabel: "Add plant",
            variant: .primary
        ) {
            activeSheet = .add
        }
    }

}

// MARK: - Preview

#Preview("Home") {
    HomeView()
}
