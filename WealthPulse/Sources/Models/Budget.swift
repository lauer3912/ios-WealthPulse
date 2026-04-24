import Foundation

struct Budget: Codable, Identifiable, Equatable {
    let id: UUID
    var category: TransactionCategory
    var monthlyLimit: Double
    var spent: Double
    var color: String
    var isCustom: Bool
    var createdAt: Date

    init(id: UUID = UUID(), category: TransactionCategory, monthlyLimit: Double, spent: Double = 0, isCustom: Bool = false) {
        self.id = id
        self.category = category
        self.monthlyLimit = monthlyLimit
        self.spent = spent
        self.color = category.color
        self.isCustom = isCustom
        self.createdAt = Date()
    }

    var remaining: Double {
        return max(0, monthlyLimit - spent)
    }

    var percentUsed: Double {
        guard monthlyLimit > 0 else { return 0 }
        return min(1.0, spent / monthlyLimit)
    }

    var isOverBudget: Bool {
        return spent > monthlyLimit
    }

    var percentOver: Double {
        guard monthlyLimit > 0 else { return 0 }
        return max(0, (spent - monthlyLimit) / monthlyLimit)
    }
}

struct BudgetRule: Codable {
    var needsPercent: Double = 0.50
    var wantsPercent: Double = 0.30
    var savingsPercent: Double = 0.20

    var totalIncome: Double = 0
    var needsAmount: Double { totalIncome * needsPercent }
    var wantsAmount: Double { totalIncome * wantsPercent }
    var savingsAmount: Double { totalIncome * savingsPercent }
}
