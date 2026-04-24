import Foundation

enum GoalIcon: String, Codable, CaseIterable {
    case house = "house.fill"
    case car = "car.fill"
    case airplane = "airplane"
    case gift = "gift.fill"
    case heart = "heart.fill"
    case star = "star.fill"
    case graduation = "graduationcap.fill"
    case briefcase = "briefcase.fill"
    case moneybag = "dollarsign.circle.fill"
    case piggy = "hare.fill"
    case umbrella = "umbrella.fill"
    case airplaneDeparture = "airplane.departure"

    var displayName: String {
        switch self {
        case .house: return "House"
        case .car: return "Car"
        case .airplane: return "Travel"
        case .gift: return "Gift"
        case .heart: return "Health"
        case .star: return "Dream"
        case .graduation: return "Education"
        case .briefcase: return "Business"
        case .moneybag: return "Savings"
        case .piggy: return "Emergency"
        case .umbrella: return "Insurance"
        case .airplaneDeparture: return "Vacation"
        }
    }
}

struct Goal: Codable, Identifiable, Equatable {
    let id: UUID
    var name: String
    var targetAmount: Double
    var currentAmount: Double
    var deadline: Date?
    var icon: GoalIcon
    var color: String
    var milestones: [Milestone]
    var createdAt: Date

    init(id: UUID = UUID(), name: String, targetAmount: Double, currentAmount: Double = 0, deadline: Date? = nil, icon: GoalIcon = .moneybag, color: String = "#34C759") {
        self.id = id
        self.name = name
        self.targetAmount = targetAmount
        self.currentAmount = currentAmount
        self.deadline = deadline
        self.icon = icon
        self.color = color
        self.milestones = []
        self.createdAt = Date()
    }

    var progress: Double {
        guard targetAmount > 0 else { return 0 }
        return min(1.0, currentAmount / targetAmount)
    }

    var remainingAmount: Double {
        return max(0, targetAmount - currentAmount)
    }

    var daysRemaining: Int? {
        guard let deadline = deadline else { return nil }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: deadline)
        return components.day
    }

    var isCompleted: Bool {
        return currentAmount >= targetAmount
    }

    var isOverdue: Bool {
        guard let deadline = deadline else { return false }
        return Date() > deadline && currentAmount < targetAmount
    }

    mutating func addMilestone(_ milestone: Milestone) {
        milestones.append(milestone)
    }
}

struct Milestone: Codable, Identifiable, Equatable {
    let id: UUID
    var title: String
    var targetAmount: Double
    var isReached: Bool
    var reachedDate: Date?

    init(id: UUID = UUID(), title: String, targetAmount: Double, isReached: Bool = false, reachedDate: Date? = nil) {
        self.id = id
        self.title = title
        self.targetAmount = targetAmount
        self.isReached = isReached
        self.reachedDate = reachedDate
    }
}
