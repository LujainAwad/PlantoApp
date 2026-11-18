
import Foundation

// Available options in the form.
enum PlantRoom: String, CaseIterable {
    case bedroom = "Bedroom"
    case livingRoom = "Living Room"
    case kitchen = "Kitchen"
    case balcony = "Balcony"
    case bathroom = "Bathroom"
}

enum PlantLight: String, CaseIterable {
    case fullSun = "Full Sun"
    case partialSun = "Partial Sun"
    case lowLight = "Low Light"
}

enum WateringFrequency: String, CaseIterable {
    case everyDay = "Every day"
    case everyTwoDays = "Every 2 days"
    case everyThreeDays = "Every 3 days"
    case onceAWeek = "Once a week"
    case everyTenDays = "Every 10 days"
    case everyTwoWeeks = "Every 2 weeks"

    var intervalDays: Int {
        switch self {
        case .everyDay: return 1
        case .everyTwoDays: return 2
        case .everyThreeDays: return 3
        case .onceAWeek: return 7
        case .everyTenDays: return 10
        case .everyTwoWeeks: return 14
        }
    }
}

enum WaterAmount: String, CaseIterable {
    case small = "20-50 ml"
    case medium = "50-100 ml"
    case large = "100-200 ml"
    case extraLarge = "200-300 ml"
}

// One plant and its watering choices.
struct Plant: Identifiable {
    let id = UUID()
    var name: String
    var room: PlantRoom
    var light: PlantLight
    var wateringFrequency: WateringFrequency
    var waterAmount: WaterAmount
    let createdAt = Date()
}
