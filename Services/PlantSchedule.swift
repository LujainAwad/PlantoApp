
//
// PlantSchedule.swift - Calculates watering dates.
//
// Contains:
// - Check if a plant needs watering on a given date.
//
// Used by: PlantViewModel, NotificationService.
//
// Learn: enum, static functions, Calendar,
// Date, guard, and modulo operator.
//

import Foundation

// MARK: - Plant Schedule

enum PlantSchedule {

    // Check if the plant needs watering on a specific day
    static func isDue(
        _ plant: Plant,
        on date: Date,
        calendar: Calendar = .current
    ) -> Bool {

        let start = calendar.startOfDay(for: plant.createdAt)
        let target = calendar.startOfDay(for: date)

        let days = calendar.dateComponents(
            [.day],
            from: start,
            to: target
        ).day ?? -1

        return days >= 0 &&
            days % plant.wateringFrequency.intervalDays == 0
    }

    // Calculate the date of a watering reminder
    static func wateringDate(
        for plant: Plant,
        occurrence: Int,
        calendar: Calendar = .current
    ) -> Date? {

        guard occurrence >= 0 else { return nil }

        return calendar.date(
            byAdding: .day,
            value: occurrence * plant.wateringFrequency.intervalDays,
            to: calendar.startOfDay(for: plant.createdAt)
        )
    }
}
