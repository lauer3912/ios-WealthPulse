import Foundation

enum SubscriptionTier: String, Codable, CaseIterable {
    case basic = "Basic"
    case premium = "Premium"

    var displayName: String {
        return rawValue
    }

    var price: Double {
        switch self {
        case .basic: return 9.99
        case .premium: return 2.99
        }
    }

    var monthlyPrice: Double {
        switch self {
        case .basic: return 9.99
        case .premium: return 2.99
        }
    }

    var yearlyPrice: Double {
        return monthlyPrice * 12 * 0.83
    }
}

enum SubscriptionPeriod: String, Codable {
    case monthly = "Monthly"
    case yearly = "Yearly"
}

struct Subscription: Codable, Equatable {
    var tier: SubscriptionTier
    var period: SubscriptionPeriod
    var expirationDate: Date
    var isActive: Bool
    var productId: String
    var transactionId: String?
    var purchaseDate: Date
    var autoRenew: Bool

    init(tier: SubscriptionTier, period: SubscriptionPeriod, expirationDate: Date, productId: String, transactionId: String? = nil, purchaseDate: Date = Date(), autoRenew: Bool = true) {
        self.tier = tier
        self.period = period
        self.expirationDate = expirationDate
        self.isActive = expirationDate > Date()
        self.productId = productId
        self.transactionId = transactionId
        self.purchaseDate = purchaseDate
        self.autoRenew = autoRenew
    }

    var isExpired: Bool {
        return expirationDate < Date()
    }

    var daysRemaining: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: expirationDate)
        return max(0, components.day ?? 0)
    }
}

struct SubscriptionFeature: Identifiable {
    let id = UUID()
    let name: String
    let isBasic: Bool
    let isPremium: Bool
    let icon: String

    static let allFeatures: [SubscriptionFeature] = [
        SubscriptionFeature(name: "Basic Budgeting", isBasic: true, isPremium: true, icon: "creditcard.fill"),
        SubscriptionFeature(name: "50/30/20 Rule", isBasic: true, isPremium: true, icon: "chart.pie.fill"),
        SubscriptionFeature(name: "Goal Tracking", isBasic: true, isPremium: true, icon: "target"),
        SubscriptionFeature(name: "Multiple Accounts", isBasic: true, isPremium: true, icon: "building.columns"),
        SubscriptionFeature(name: "Basic Reports", isBasic: true, isPremium: true, icon: "chart.bar.fill"),
        SubscriptionFeature(name: "Investment Tracker", isBasic: false, isPremium: true, icon: "chart.line.uptrend.xyaxis"),
        SubscriptionFeature(name: "Tax Center", isBasic: false, isPremium: true, icon: "doc.text.fill"),
        SubscriptionFeature(name: "Unlimited Accounts", isBasic: false, isPremium: true, icon: "infinity"),
        SubscriptionFeature(name: "PDF Export", isBasic: false, isPremium: true, icon: "arrow.down.doc.fill"),
        SubscriptionFeature(name: "Priority Support", isBasic: false, isPremium: true, icon: "headphones"),
    ]
}
