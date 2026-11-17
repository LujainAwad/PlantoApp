
import Foundation

// MARK: - Plant Room

enum PlantRoom: String, CaseIterable, Codable {
    case bedroom = "Bedroom"
    case livingRoom = "Living Room"
    case kitchen = "Kitchen"
    case balcony = "Balcony"
    case bathroom = "Bathroom"
}

// MARK: - Plant Light

enum PlantLight: String, CaseIterable, Codable {
    case fullSun = "Full Sun"
    case partialSun = "Partial Sun"
    case lowLight = "Low Light"
}

// MARK: - Watering Frequency

enum WateringFrequency: String, CaseIterable, Codable {
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

// MARK: - Water Amount

enum WaterAmount: String, CaseIterable, Codable {
    case small = "20-50 ml"
    case medium = "50-100 ml"
    case large = "100-200 ml"
    case extraLarge = "200-300 ml"
}

// MARK: - Plant Model

struct Plant: Identifiable, Codable {
    let id: UUID
    var name: String
    var room: PlantRoom
    var light: PlantLight
    var wateringFrequency: WateringFrequency
    var waterAmount: WaterAmount
    var createdAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        room: PlantRoom,
        light: PlantLight,
        wateringFrequency: WateringFrequency,
        waterAmount: WaterAmount,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.room = room
        self.light = light
        self.wateringFrequency = wateringFrequency
        self.waterAmount = waterAmount
        self.createdAt = createdAt
    }
}
