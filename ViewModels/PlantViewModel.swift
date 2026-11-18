
import Foundation
import Observation

enum HomeScreenState {
    case empty
    case noReminders
    case todayReminders
    case allDone
}

@MainActor
@Observable
final class PlantViewModel {

    var plants: [Plant] = []
    var completedIDs: [UUID] = []

    private var lastDay = Date()
    private var hasAddedPlant = false

    private let notifications = NotificationService()

    // Today's reminders
    var todayReminders: [Plant] {
        let calendar = Calendar.current

        return plants.filter { plant in
            let days = calendar.dateComponents(
                [.day],
                from: calendar.startOfDay(for: plant.createdAt),
                to: calendar.startOfDay(for: Date())
            ).day ?? -1

            return days >= 0 &&
                days % plant.wateringFrequency.intervalDays == 0
        }
    }

    var totalCount: Int {
        todayReminders.count
    }

    var completedCount: Int {
        todayReminders.filter {
            isCompleted($0)
        }.count
    }

    // Home screen
    var screenState: HomeScreenState {
        if plants.isEmpty {
            return hasAddedPlant ? .noReminders : .empty
        }

        if todayReminders.isEmpty {
            return .noReminders
        }

        if completedCount == totalCount {
            return .allDone
        }

        return .todayReminders
    }

    // Add or edit
    func savePlant(_ plant: Plant) {
        if let index = plants.firstIndex(where: {
            $0.id == plant.id
        }) {
            plants[index] = plant
        } else {
            plants.append(plant)
            hasAddedPlant = true
        }

        notifications.schedule(for: plant)
    }

    // Delete
    func deletePlant(_ plant: Plant) {
        plants.removeAll { $0.id == plant.id }
        completedIDs.removeAll { $0 == plant.id }
        notifications.cancel(for: plant)
    }

    // Watering completion
    func isCompleted(_ plant: Plant) -> Bool {
        Calendar.current.isDateInToday(lastDay) &&
        completedIDs.contains(plant.id)
    }

    func toggleReminder(for plant: Plant) {
        refreshDailyReminders()

        if isCompleted(plant) {
            completedIDs.removeAll { $0 == plant.id }
        } else {
            completedIDs.append(plant.id)
        }
    }

    // New day
    func refreshDailyReminders() {
        if !Calendar.current.isDateInToday(lastDay) {
            completedIDs.removeAll()
            lastDay = Date()
        }
    }
}
