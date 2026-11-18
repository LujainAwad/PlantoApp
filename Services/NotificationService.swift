
import Foundation
import UserNotifications

class NotificationService {

    let center = UNUserNotificationCenter.current()

    init() {
        center.removeAllPendingNotificationRequests()
    }

    // Schedule notification
    func schedule(for plant: Plant) {

        cancel(for: plant)

        
        let seconds = Double(plant.wateringFrequency.intervalDays * 86400)


        center.requestAuthorization(options: [.alert, .sound]) { allowed, error in

            if !allowed {
                return
            }

            let content = UNMutableNotificationContent()
            content.title = "Planto 🌱"
            content.body = "Time to water \(plant.name) 💧"
            content.sound = .default

            let trigger = UNTimeIntervalNotificationTrigger(
                timeInterval: seconds,
                repeats: true
            )

            let request = UNNotificationRequest(
                identifier: plant.id.uuidString,
                content: content,
                trigger: trigger
            )

            self.center.add(request)
        }
    }

    // Cancel notification
    func cancel(for plant: Plant) {
        center.removePendingNotificationRequests(
            withIdentifiers: [plant.id.uuidString]
        )
    }
}
