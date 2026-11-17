// PlantViewModel.swift - Manages plant data and app logic.
// daily completion storage, and notifications.
//
// Contains:
// - Load and save plants.
// - Add, edit, and delete plants.
// - Track daily watering completion.
// - Detect previous plant usage.
// - Synchronize local notifications.
// - Skip today's reminder when completed.
//
// Used by: HomeView, SetReminderView.
//
// Learn: @Observable, @MainActor, Set,
// computed properties, Task, and async/await.
//

import Foundation
import Observation

// MARK: - Home Screen State

enum HomeScreenState {
    case empty, noReminders, todayReminders, allDone
}

// MARK: - Plant ViewModel

@MainActor
@Observable
final class PlantViewModel {

    // MARK: - Properties

    var plants: [Plant] = []
    private(set) var completedPlantIDs: Set<UUID> = []
    private var completionDate = Calendar.current.startOfDay(for: Date())

    @ObservationIgnored private let notifications = NotificationService()
    @ObservationIgnored private var notificationTask: Task<Void, Never>?

    // MARK: - Local Storage

    private enum StorageKeys {
        static let plants = "savedPlants"
        static let completions = "dailyCompletions"
    }

    private struct DailyCompletion: Codable {
        let date: Date
        let plantIDs: Set<UUID>
    }

    // MARK: - Initialization

    init() {
        plants = loadPlants()
        completedPlantIDs = loadCompletions()
        refreshNotifications()
    }

    // MARK: - Home Screen

    var hasSavedPlantsBefore: Bool {
        UserDefaults.standard.object(
            forKey: StorageKeys.plants
        ) != nil
    }

    var todayReminders: [Plant] {
        plants.filter {
            PlantSchedule.isDue($0, on: Date())
        }
    }

    var completedCount: Int {
        todayReminders.filter { isCompleted($0) }.count
    }

    var totalCount: Int {
        todayReminders.count
    }

    var allRemindersCompleted: Bool {
        totalCount > 0 && completedCount == totalCount
    }

    var screenState: HomeScreenState {
        if plants.isEmpty {
            return hasSavedPlantsBefore ? .noReminders : .empty
        }

        if todayReminders.isEmpty {
            return .noReminders
        }

        return allRemindersCompleted ? .allDone : .todayReminders
    }

    var shouldShowAddButton: Bool {
        screenState != .empty
    }

    // MARK: - Plant Actions

    func addPlant(_ plant: Plant) {
        plants.append(plant)
        savePlants()
        refreshNotifications(requestPermission: true)
    }

    func updatePlant(_ updatedPlant: Plant) {
        guard let index = plants.firstIndex(where: {
            $0.id == updatedPlant.id
        }) else {
            return
        }

        plants[index] = updatedPlant
        savePlants()
        refreshNotifications()
    }

    @discardableResult
    func savePlant(
        name: String,
        room: PlantRoom,
        light: PlantLight,
        frequency: WateringFrequency,
        waterAmount: WaterAmount,
        editingPlant: Plant? = nil
    ) -> Bool {

        let cleanName = name.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanName.isEmpty else { return false }

        if var plant = editingPlant {
            plant.name = cleanName
            plant.room = room
            plant.light = light
            plant.wateringFrequency = frequency
            plant.waterAmount = waterAmount

            updatePlant(plant)
        } else {
            let plant = Plant(
                name: cleanName,
                room: room,
                light: light,
                wateringFrequency: frequency,
                waterAmount: waterAmount
            )

            addPlant(plant)
        }

        return true
    }

    func deletePlant(_ plant: Plant) {
        resetCompletionsIfNeeded()

        plants.removeAll { $0.id == plant.id }
        completedPlantIDs.remove(plant.id)

        savePlants()
        saveCompletions()
        refreshNotifications()
    }

    // MARK: - Daily Watering

    func isCompleted(_ plant: Plant) -> Bool {
        let today = Calendar.current.startOfDay(for: Date())

        return completionDate == today &&
            completedPlantIDs.contains(plant.id)
    }

    func toggleReminder(for plant: Plant) {
        resetCompletionsIfNeeded()

        guard todayReminders.contains(where: {
            $0.id == plant.id
        }) else {
            return
        }

        if completedPlantIDs.contains(plant.id) {
            completedPlantIDs.remove(plant.id)
        } else {
            completedPlantIDs.insert(plant.id)
        }

        saveCompletions()
        refreshNotifications()
    }

    func refreshDailyReminders() {
        resetCompletionsIfNeeded()
        refreshNotifications()
    }

    private func resetCompletionsIfNeeded() {
        let today = Calendar.current.startOfDay(for: Date())

        guard completionDate != today else { return }

        completionDate = today
        completedPlantIDs.removeAll()

        saveCompletions()
    }

    // MARK: - Local Storage

    private func savePlants() {
        guard let data = try? JSONEncoder().encode(plants) else {
            return
        }

        UserDefaults.standard.set(
            data,
            forKey: StorageKeys.plants
        )
    }

    private func loadPlants() -> [Plant] {
        guard let data = UserDefaults.standard.data(
            forKey: StorageKeys.plants
        ) else {
            return []
        }

        return (try? JSONDecoder().decode(
            [Plant].self,
            from: data
        )) ?? []
    }

    private func saveCompletions() {
        let completion = DailyCompletion(
            date: completionDate,
            plantIDs: completedPlantIDs
        )

        guard let data = try? JSONEncoder().encode(completion) else {
            return
        }

        UserDefaults.standard.set(
            data,
            forKey: StorageKeys.completions
        )
    }

    private func loadCompletions() -> Set<UUID> {
        guard
            let data = UserDefaults.standard.data(
                forKey: StorageKeys.completions
            ),
            let completion = try? JSONDecoder().decode(
                DailyCompletion.self,
                from: data
            ),
            Calendar.current.isDate(
                completion.date,
                inSameDayAs: Date()
            )
        else {
            return []
        }

        return completion.plantIDs
    }

    // MARK: - Notifications

    private func refreshNotifications(
        requestPermission: Bool = false
    ) {
        let previousTask = notificationTask

        notificationTask = Task {
            await previousTask?.value

            if requestPermission {
                guard await notifications.requestPermission() else {
                    print("Notification permission unavailable")
                    return
                }
            }

            await notifications.refreshReminders(
                for: plants,
                completedPlantIDs: completedPlantIDs
            )
        }
    }
}
