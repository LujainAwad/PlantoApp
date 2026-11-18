
import SwiftUI

struct SetReminderView: View {

    @Environment(\.dismiss) private var dismiss

    let viewModel: PlantViewModel
    var editingPlant: Plant? = nil

    // MARK: - Properties

    @State private var plantName = ""
    @State private var selectedRoom: PlantRoom = .bedroom
    @State private var selectedLight: PlantLight = .fullSun
    @State private var selectedFrequency: WateringFrequency = .everyDay
    @State private var selectedWater: WaterAmount = .small

    // MARK: - Body

    var body: some View {

        VStack(spacing: 0) {

            // MARK: - Header

            HStack {

                AppIconButton(
                    icon: "xmark",
                    accessibilityLabel: "Close",
                    variant: .secondary
                ) {
                    dismiss()
                }

                Spacer()

                Text("Set Reminder")
                    .font(AppFonts.formHeader)
                    .foregroundStyle(AppColors.primaryText)

                Spacer()

                AppIconButton(
                    icon: "checkmark",
                    accessibilityLabel: "Save plant"
                ) {
                    savePlant()
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 18)

            ScrollView {

                VStack(spacing: 40) {

                    // MARK: - Plant Name

                    HStack(spacing: 12) {

                        Text("Plant Name")
                            .foregroundStyle(AppColors.primaryText)

                        TextField("Pothos", text: $plantName)
                            .foregroundStyle(AppColors.primaryText)
                            .tint(AppColors.cursorMint)
                    }
                    .padding(.horizontal, 20)
                    .frame(height: 59)
                    .background(
                        AppColors.cardBackground,
                        in: RoundedRectangle(cornerRadius: 30)
                    )

                    // MARK: - Room and Light

                    VStack(spacing: 0) {

                        // Room Picker

                        Menu {
                            Picker("Room", selection: $selectedRoom) {
                                ForEach(PlantRoom.allCases, id: \.self) { room in
                                    Text(room.rawValue).tag(room)
                                }
                            }
                        } label: {
                            PlantFormRow(
                                icon: "location",
                                title: "Room",
                                value: selectedRoom.rawValue
                            )
                        }

                        Rectangle()
                            .fill(AppColors.fieldDivider)
                            .frame(height: 1)
                            .padding(.horizontal, 16)

                        // Light Picker

                        Menu {
                            Picker("Light", selection: $selectedLight) {
                                ForEach(PlantLight.allCases, id: \.self) { light in
                                    Text(light.rawValue).tag(light)
                                }
                            }
                        } label: {
                            PlantFormRow(
                                icon: "sun.max",
                                title: "Light",
                                value: selectedLight.rawValue
                            )
                        }
                    }
                    .background(
                        AppColors.cardBackground,
                        in: RoundedRectangle(cornerRadius: 30)
                    )

                    // MARK: - Watering Days and Water

                    VStack(spacing: 0) {

                        // Watering Days Picker

                        Menu {
                            Picker("Watering Days", selection: $selectedFrequency) {
                                ForEach(WateringFrequency.allCases, id: \.self) { day in
                                    Text(day.rawValue).tag(day)
                                }
                            }
                        } label: {
                            PlantFormRow(
                                icon: "drop",
                                title: "Watering Days",
                                value: selectedFrequency.rawValue
                            )
                        }

                        Rectangle()
                            .fill(AppColors.fieldDivider)
                            .frame(height: 1)
                            .padding(.horizontal, 16)

                        // Water Amount Picker

                        Menu {
                            Picker("Water", selection: $selectedWater) {
                                ForEach(WaterAmount.allCases, id: \.self) { amount in
                                    Text(amount.rawValue).tag(amount)
                                }
                            }
                        } label: {
                            PlantFormRow(
                                icon: "drop",
                                title: "Water",
                                value: selectedWater.rawValue
                            )
                        }
                    }
                    .background(
                        AppColors.cardBackground,
                        in: RoundedRectangle(cornerRadius: 30)
                    )

                    // MARK: - Delete Reminder

                    if let plant = editingPlant {
                        Button {
                            viewModel.deletePlant(plant)
                            dismiss()
                        } label: {
                            Text("Delete Reminder")
                                .font(AppFonts.destructiveButton)
                                .foregroundStyle(AppColors.destructive)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(
                                    AppColors.cardBackground,
                                    in: RoundedRectangle(cornerRadius: 12)
                                )
                        }
                        .padding(.top, 24)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.sheetBackground)
        .presentationCornerRadius(39)

        // MARK: - Load Plant For Editing

        .onAppear {
            if let plant = editingPlant {
                plantName = plant.name
                selectedRoom = plant.room
                selectedLight = plant.light
                selectedFrequency = plant.wateringFrequency
                selectedWater = plant.waterAmount
            }
        }
    }

    // MARK: - Save Plant

    private func savePlant() {

        let name = plantName.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !name.isEmpty else { return }

        var plant = editingPlant ?? Plant(
            name: name,
            room: selectedRoom,
            light: selectedLight,
            wateringFrequency: selectedFrequency,
            waterAmount: selectedWater
        )

        plant.name = name
        plant.room = selectedRoom
        plant.light = selectedLight
        plant.wateringFrequency = selectedFrequency
        plant.waterAmount = selectedWater

        viewModel.savePlant(plant)
        dismiss()
    }
}

#Preview {
    SetReminderView(viewModel: PlantViewModel())
}
