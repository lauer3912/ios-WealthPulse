import Foundation

enum AccountType: String, Codable, CaseIterable {
    case checking = "Checking"
    case savings = "Savings"
    case creditCard = "Credit Card"
    case investment = "Investment"
    case retirement = "401k / IRA"
    case cash = "Cash"
    case other = "Other"

    var icon: String {
        switch self {
        case .checking: return "building.columns"
        case .savings: return "banknote"
        case .creditCard: return "creditcard"
        case .investment: return "chart.line.uptrend.xyaxis"
        case .retirement: return "chart.pie"
        case .cash: return "dollarsign.circle"
        case .other: return "folder"
        }
    }
}

struct Account: Codable, Identifiable, Equatable {
    let id: UUID
    var name: String
    var type: AccountType
    var balance: Double
    var currency: String
    var color: String
    var createdAt: Date

    init(id: UUID = UUID(), name: String, type: AccountType, balance: Double = 0, currency: String = "USD", color: String = "#34C759") {
        self.id = id
        self.name = name
        self.type = type
        self.balance = balance
        self.currency = currency
        self.color = color
        self.createdAt = Date()
    }
}
