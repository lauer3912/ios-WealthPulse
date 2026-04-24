import Foundation
import Combine

final class BudgetViewModel: ObservableObject {
    @Published var budgets: [Budget] = []
    @Published var totalBudget: Double = 0
    @Published var totalSpent: Double = 0
    @Published var totalRemaining: Double = 0
    @Published var budgetRule: BudgetRule = BudgetRule()
    @Published var monthlyIncome: Double = 0
    @Published var overBudgetCount: Int = 0

    private let dataService = DataService.shared

    init() {
        loadData()
    }

    func loadData() {
        budgets = dataService.getBudgets()
        monthlyIncome = dataService.getMonthlyIncome()
        budgetRule = dataService.getBudgetRule()
        budgetRule.totalIncome = monthlyIncome

        totalBudget = budgets.reduce(0) { $0 + $1.monthlyLimit }
        totalSpent = budgets.reduce(0) { $0 + $1.spent }
        totalRemaining = max(0, totalBudget - totalSpent)
        overBudgetCount = budgets.filter { $0.isOverBudget }.count
    }

    func addBudget(category: TransactionCategory, monthlyLimit: Double) {
        _ = dataService.createBudget(category: category, monthlyLimit: monthlyLimit)
        loadData()
    }

    func updateBudget(_ budget: Budget) {
        dataService.updateBudget(budget)
        loadData()
    }

    func deleteBudget(_ budget: Budget) {
        dataService.deleteBudget(budget)
        loadData()
    }

    func resetBudgets() {
        dataService.resetBudgetsForNewMonth()
        loadData()
    }

    var needsAmount: Double {
        return budgetRule.totalIncome * 0.50
    }

    var wantsAmount: Double {
        return budgetRule.totalIncome * 0.30
    }

    var savingsAmount: Double {
        return budgetRule.totalIncome * 0.20
    }

    var needsSpent: Double {
        return budgets.filter { needsCategories.contains($0.category) }.reduce(0) { $0 + $1.spent }
    }

    var wantsSpent: Double {
        return budgets.filter { wantsCategories.contains($0.category) }.reduce(0) { $0 + $1.spent }
    }

    var savingsActual: Double {
        return dataService.getMonthlySavings()
    }

    private var needsCategories: Set<TransactionCategory> {
        return [.housing, .bills, .health, .transport, .food, .education]
    }

    private var wantsCategories: Set<TransactionCategory> {
        return [.shopping, .entertainment, .travel, .subscription, .otherExpense]
    }

    var needsProgress: Double {
        guard needsAmount > 0 else { return 0 }
        return min(1.0, needsSpent / needsAmount)
    }

    var wantsProgress: Double {
        guard wantsAmount > 0 else { return 0 }
        return min(1.0, wantsSpent / wantsAmount)
    }

    var savingsProgress: Double {
        guard savingsAmount > 0 else { return 0 }
        return min(1.0, savingsActual / savingsAmount)
    }

    var is50_30_20Balanced: Bool {
        let tolerance = 0.1
        return abs(needsProgress - 1.0) <= tolerance &&
               abs(wantsProgress - 1.0) <= tolerance &&
               savingsProgress >= 0.8
    }

    var overallHealthMessage: String {
        if is50_30_20Balanced {
            return "Perfect! You're following the 50/30/20 rule."
        } else if overBudgetCount > 0 {
            return "\(overBudgetCount) categories over budget"
        } else {
            return "On track with your budget"
        }
    }
}
