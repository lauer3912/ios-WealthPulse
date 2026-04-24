import Foundation

enum TransactionType: String, Codable, CaseIterable {
    case income = "Income"
    case expense = "Expense"
}

enum TransactionCategory: String, Codable, CaseIterable {
    // Income
    case salary = "Salary"
    case freelance = "Freelance"
    case investment = "Investment Income"
    case gift = "Gift"
    case refund = "Refund"
    case otherIncome = "Other Income"

    // Expense
    case food = "Food & Dining"
    case transport = "Transportation"
    case shopping = "Shopping"
    case entertainment = "Entertainment"
    case bills = "Bills & Utilities"
    case health = "Health & Fitness"
    case housing = "Housing"
    case education = "Education"
    case travel = "Travel"
    case subscription = "Subscriptions"
    case otherExpense = "Other Expense"

    var icon: String {
        switch self {
        case .salary: return "dollarsign.circle.fill"
        case .freelance: return "briefcase.fill"
        case .investment: return "chart.line.uptrend.xyaxis"
        case .gift: return "gift.fill"
        case .refund: return "arrow.uturn.left.circle.fill"
        case .otherIncome: return "plus.circle.fill"
        case .food: return "fork.knife"
        case .transport: return "car.fill"
        case .shopping: return "bag.fill"
        case .entertainment: return "tv.fill"
        case .bills: return "doc.text.fill"
        case .health: return "heart.fill"
        case .housing: return "house.fill"
        case .education: return "book.fill"
        case .travel: return "airplane"
        case .subscription: return "repeat.circle.fill"
        case .otherExpense: return "minus.circle.fill"
        }
    }

    var color: String {
        switch self {
        case .salary, .freelance, .investment, .gift, .refund, .otherIncome:
            return "#34C759"
        case .food: return "#FF9500"
        case .transport: return "#007AFF"
        case .shopping: return "#FF2D55"
        case .entertainment: return "#AF52DE"
        case .bills: return "#5856D6"
        case .health: return "#FF3B30"
        case .housing: return "#00C7BE"
        case .education: return "#32ADE6"
        case .travel: return "#34C759"
        case .subscription: return "#FF6482"
        case .otherExpense: return "#8E8E93"
        }
    }
}

struct Transaction: Codable, Identifiable, Equatable {
    let id: UUID
    var amount: Double
    var type: TransactionType
    var category: TransactionCategory
    var note: String
    var date: Date
    var accountId: UUID?
    var isRecurring: Bool
    var recurringInterval: String?
    var createdAt: Date

    init(id: UUID = UUID(), amount: Double, type: TransactionType, category: TransactionCategory, note: String = "", date: Date = Date(), accountId: UUID? = nil, isRecurring: Bool = false, recurringInterval: String? = nil) {
        self.id = id
        self.amount = amount
        self.type = type
        self.category = category
        self.note = note
        self.date = date
        self.accountId = accountId
        self.isRecurring = isRecurring
        self.recurringInterval = recurringInterval
        self.createdAt = Date()
    }
}
