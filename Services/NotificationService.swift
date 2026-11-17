
//
// NotificationService.swift - Manages local watering reminders.
//
// Contains:
// - Request notification permission.
// - Schedule upcoming watering dates.
// - Skip completed plants for today.
// - Update reminders after plant changes.
// - Cancel reminders for deleted plants.
// - Print scheduled reminders for debugging.
//
// Used by: PlantViewModel.
//
// Learn: UserNotifications, async/await,
// DateComponents, Calendar, Set, Dictionary,
// and UNCalendarNotificationTrigger.
//

import Foundation
import UserNotifications

// MARK: - Notification Service

@MainActor
final class NotificationService {

    // MARK: - Properties

    private let center = UNUserNotificationCenter.current()

    private let calendar = Calendar.current

    private let reminderHour = 9
    private let reminderMinute = 0

    private let remindersPerPlant = 8

    // Leave a little room below the iOS pending limit.
    private let maximumReminders = 60

    private let reminderPrefix = "planto.reminder."

    // MARK: - Request Permission

    func requestPermission() async -> Bool {

        let settings = await center.notificationSettings()

        switch settings.authorizationStatus {

        case .authorized, .provisional:
            return true

        #if os(iOS)
        case .ephemeral:
            return true
        #endif

        case .denied:
            return false

        case .notDetermined:

            do {
                return try await center.requestAuthorization(
                    options: [.alert, .badge, .sound]
                )
            } catch {
                print("❌ Permission error: \(error)")
                return false
            }

        @unknown default:
            return false
        }
    }

    // MARK: - Check Permission

    private func isAuthorized() async -> Bool {

        let settings = await center.notificationSettings()

        switch settings.authorizationStatus {

        case .authorized, .provisional:
            return true

        #if os(iOS)
        case .ephemeral:
            return true
        #endif

        default:
            return false
        }
    }

    // MARK: - Synchronize All Reminders

    func refreshReminders(
        for plants: [Plant],
        completedPlantIDs: Set<UUID>
    ) async {

        guard await isAuthorized() else {
            print("🔔 Notifications not authorized")
            return
        }

        let now = Date()

        // Generate the reminders we actually need.
        var desiredRequests: [UNNotificationRequest] = []

        for plant in plants {

            let requests = makeRequests(
                for: plant,
                completedPlantIDs: completedPlantIDs,
                now: now
            )

            desiredRequests.append(contentsOf: requests)
        }

        // Prioritize the nearest reminders.
        desiredRequests.sort { first, second in

            let firstDate =
                (first.trigger as? UNCalendarNotificationTrigger)?
                    .nextTriggerDate() ?? .distantFuture

            let secondDate =
                (second.trigger as? UNCalendarNotificationTrigger)?
                    .nextTriggerDate() ?? .distantFuture

            return firstDate < secondDate
        }

        desiredRequests = Array(
            desiredRequests.prefix(maximumReminders)
        )

        // Find previously scheduled Planto reminders.
        let pending = await center.pendingNotificationRequests()

        let existingRequests = pending.filter {
            $0.identifier.hasPrefix(reminderPrefix)
        }

        let desiredIDs = Set(
            desiredRequests.map(\.identifier)
        )

        // Remove obsolete reminders.
        let obsoleteIDs = existingRequests
            .map(\.identifier)
            .filter { !desiredIDs.contains($0) }

        if !obsoleteIDs.isEmpty {

            center.removePendingNotificationRequests(
                withIdentifiers: obsoleteIDs
            )
        }

        // Compare existing content before scheduling.
        let existingByID = Dictionary(
            uniqueKeysWithValues: existingRequests.map {
                ($0.identifier, $0)
            }
        )

        for request in desiredRequests {

            if let existing = existingByID[request.identifier] {

                let sameTitle =
                    existing.content.title == request.content.title

                let sameBody =
                    existing.content.body == request.content.body

                let oldDate =
                    (existing.trigger as? UNCalendarNotificationTrigger)?
                        .nextTriggerDate()

                let newDate =
                    (request.trigger as? UNCalendarNotificationTrigger)?
                        .nextTriggerDate()

                if sameTitle && sameBody && oldDate == newDate {
                    continue
                }
            }

            do {
                try await center.add(request)
            } catch {
                print(
                    "❌ Scheduling error for \(request.identifier): \(error)"
                )
            }
        }

        #if DEBUG
        await printScheduledReminders()
        #endif
    }

    // MARK: - Create Plant Reminder Requests

    private func makeRequests(
        for plant: Plant,
        completedPlantIDs: Set<UUID>,
        now: Date
    ) -> [UNNotificationRequest] {

        var requests: [UNNotificationRequest] = []

        let startDay = calendar.startOfDay(
            for: plant.createdAt
        )

        let today = calendar.startOfDay(for: now)

        let interval = plant.wateringFrequency.intervalDays

        let elapsedDays = calendar.dateComponents(
            [.day],
            from: startDay,
            to: today
        ).day ?? 0

        var occurrence = max(0, elapsedDays / interval)

        // Generate eight upcoming watering reminders.
        while requests.count < remindersPerPlant {

            guard let reminderDay = PlantSchedule.wateringDate(
                for: plant,
                occurrence: occurrence,
                calendar: calendar
            ) else {
                break
            }


            occurrence += 1

            guard let reminderDate = calendar.date(
                bySettingHour: reminderHour,
                minute: reminderMinute,
                second: 0,
                of: reminderDay
            ) else {
                break
            }

            // Do not schedule past times.
            guard reminderDate > now else {
                continue
            }

            let isToday = calendar.isDateInToday(
                reminderDate
            )

            let isCompletedToday =
                completedPlantIDs.contains(plant.id)

            // Skip only today's reminder when completed.
            if isToday && isCompletedToday {
                continue
            }

            let components = calendar.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: reminderDate
            )

            let trigger = UNCalendarNotificationTrigger(
                dateMatching: components,
                repeats: false
            )

            let content = UNMutableNotificationContent()

            content.title = "Planto 🌱"

            content.body =
                "Hey! Let's water your \(plant.name) 💧"

            content.sound = .default

            // Each plant + date gets a unique identifier.
            let dateID = String(
                format: "%04d%02d%02d",
                components.year ?? 0,
                components.month ?? 0,
                components.day ?? 0
            )

            let identifier =
                reminderPrefix +
                plant.id.uuidString +
                "." +
                dateID

            let request = UNNotificationRequest(
                identifier: identifier,
                content: content,
                trigger: trigger
            )

            requests.append(request)
        }

        return requests
    }


    // MARK: - Debug Scheduled Reminders

    func printScheduledReminders() async {

        let requests = await center.pendingNotificationRequests()

        let reminders = requests.filter {
            $0.identifier.hasPrefix(reminderPrefix)
        }

        print("🌱 Scheduled plant reminders: \(reminders.count)")

        for request in reminders {

            print("━━━━━━━━━━━━━━━━━━━━")
            print("🌱 ID: \(request.identifier)")
            print("🌱 Body: \(request.content.body)")

            if let trigger = request.trigger
                as? UNCalendarNotificationTrigger {

                print(
                    "🌱 Next reminder: \(String(describing: trigger.nextTriggerDate()))"
                )
            }
        }
    }
}
