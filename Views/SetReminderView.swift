
//
// SetReminderView.swift - Adds and edits plant reminders.
//
// Contains:
// - Plant name input.
// - Room, light, watering frequency, and water selection.
// - Reusable form components.
// - Liquid Glass save and close buttons.
// - Delete confirmation when editing.
// - Keyboard focus and sheet dismissal.
//
// Used by: HomeView.
//
// Learn: @State, @FocusState, @Environment,
// TextField, Menu, ForEach, and MVVM data binding.
//

import SwiftUI

// MARK: - Set Reminder View

struct SetReminderView: View {

    // MARK: - Environment

    @Environment(\.dismiss) private var dismiss

    // MARK: - ViewModel

    let plantViewModel: PlantViewModel
    let editingPlant: Plant?

    // MARK: - Form State

    @State private var plantName: String
    @State private var selectedRoom: PlantRoom
    @State private var selectedLight: PlantLight
    @State private var selectedFrequency: WateringFrequency
    @State private var selectedWater: WaterAmount

    // MARK: - UI State

    @State private var showDeleteConfirmation = false
    @FocusState private var isNameFocused: Bool

    // MARK: - Initializer

    init(
        plantStore: PlantViewModel,
        editingPlant: Plant? = nil
    ) {
        self.plantViewModel = plantStore
        self.editingPlant = editingPlant

        _plantName = State(
            initialValue: editingPlant?.name ?? ""
        )
        _selectedRoom = State(
            initialValue: editingPlant?.room ?? .bedroom
        )
        _selectedLight = State(
            initialValue: editingPlant?.light ?? .fullSun
        )
        _selectedFrequency = State(
            initialValue: editingPlant?.wateringFrequency ?? .everyDay
        )
        _selectedWater = State(
            initialValue: editingPlant?.waterAmount ?? .small
        )
    }

    // MARK: - Form Validation

    private var isValid: Bool {
        !plantName.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView {
                VStack(spacing: 0) {
                    plantNameField

                    roomAndLightCard
                        .padding(.top, 40)

                    wateringCard
                        .padding(.top, 40)

                    if editingPlant != nil {
                        deleteButton
                            .padding(.top, 64)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 40)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .background(AppColors.sheetBackground)
        .preferredColorScheme(.dark)
        .presentationCornerRadius(39)

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
                deletePlant()
            }

            Button("Cancel", role: .cancel) {}

        } message: {
            Text(
                "This plant reminder will be permanently deleted."
            )
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            closeButton

            Spacer()

            Text("Set Reminder")
                .font(AppFonts.formHeader)
                .foregroundStyle(AppColors.primaryText)

            Spacer()

            saveButton
        }
        .padding(.horizontal, 24)
        .padding(.top, 18)
    }

    // MARK: - Plant Name Field

    private var plantNameField: some View {
        HStack(spacing: 12) {
            Text("Plant Name")
                .font(.system(size: 17))
                .foregroundStyle(AppColors.primaryText)
                .fixedSize(
                    horizontal: true,
                    vertical: false
                )

            TextField(
                "Pothos",
                text: $plantName
            )
            .font(.system(size: 17))
            .foregroundStyle(AppColors.primaryText)
            .tint(AppColors.cursorMint)
            .textInputAutocapitalization(.words)
            .autocorrectionDisabled()
            .textContentType(.none)
            .keyboardType(.default)
            .submitLabel(.done)
            .focused($isNameFocused)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .layoutPriority(1)
            .onSubmit {
                isNameFocused = false
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 59)
        .background(
            AppColors.cardBackground,
            in: RoundedRectangle(cornerRadius: 30)
        )
    }

    // MARK: - Room & Light Card

    private var roomAndLightCard: some View {
        PlantFormCard {

            // Room Picker
            Menu {
                ForEach(
                    PlantRoom.allCases,
                    id: \.self
                ) { room in
                    Button(room.rawValue) {
                        selectedRoom = room
                    }
                }
            } label: {
                PlantFormRow(
                    icon: "location",
                    title: "Room",
                    value: selectedRoom.rawValue
                )
            }
            .buttonStyle(.plain)

        } secondRow: {

            // Light Picker
            Menu {
                ForEach(
                    PlantLight.allCases,
                    id: \.self
                ) { light in
                    Button(light.rawValue) {
                        selectedLight = light
                    }
                }
            } label: {
                PlantFormRow(
                    icon: "sun.max",
                    title: "Light",
                    value: selectedLight.rawValue
                )
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Watering Card

    private var wateringCard: some View {
        PlantFormCard {

            // Watering Frequency Picker
            Menu {
                ForEach(
                    WateringFrequency.allCases,
                    id: \.self
                ) { frequency in
                    Button(frequency.rawValue) {
                        selectedFrequency = frequency
                    }
                }
            } label: {
                PlantFormRow(
                    icon: "drop",
                    title: "Watering Days",
                    value: selectedFrequency.rawValue
                )
            }
            .buttonStyle(.plain)

        } secondRow: {

            // Water Amount Picker
            Menu {
                ForEach(
                    WaterAmount.allCases,
                    id: \.self
                ) { amount in
                    Button(amount.rawValue) {
                        selectedWater = amount
                    }
                }
            } label: {
                PlantFormRow(
                    icon: "drop",
                    title: "Water",
                    value: selectedWater.rawValue
                )
            }
            .buttonStyle(.plain)
        }
    }
    // MARK: - Close Button

    private var closeButton: some View {
        AppIconButton(
            icon: "xmark",
            accessibilityLabel: "Close",
            variant: .secondary
        ) {
            isNameFocused = false
            dismiss()
        }
    }

    // MARK: - Save Button

    private var saveButton: some View {
        AppIconButton(
            icon: "checkmark",
            accessibilityLabel: "Save plant",
            variant: .primary,
            isDisabled: !isValid,
            action: savePlant
        )
    }


    // MARK: - Delete Button

    private var deleteButton: some View {
        Button(role: .destructive) {
            showDeleteConfirmation = true

        } label: {
            Text("Delete Reminder")
                .font(AppFonts.destructiveButton)
                .foregroundStyle(AppColors.destructive)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    AppColors.cardBackground,
                    in: Capsule()
                )
        }
    }

    // MARK: - Save Plant

    private func savePlant() {
        isNameFocused = false

        let didSave = plantViewModel.savePlant(
            name: plantName,
            room: selectedRoom,
            light: selectedLight,
            frequency: selectedFrequency,
            waterAmount: selectedWater,
            editingPlant: editingPlant
        )

        if didSave {
            dismiss()
        }
    }

    // MARK: - Delete Plant

    private func deletePlant() {
        guard let editingPlant else {
            return
        }

        isNameFocused = false
        plantViewModel.deletePlant(editingPlant)
        dismiss()
    }
}

// MARK: - Preview

#Preview("Add Plant") {
    SetReminderView(
        plantStore: PlantViewModel()
    )
}
