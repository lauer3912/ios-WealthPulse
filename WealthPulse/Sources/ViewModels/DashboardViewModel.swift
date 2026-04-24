import Foundation
import Combine

final class DashboardViewModel: ObservableObject {
    @Published var wealthScore: Int = 0
    @Published var totalNetWorth: Double = 0
    @Published var monthlyIncome: Double = 0
    @Published var monthlyExpenses: Double = 0
    @Published var monthlySavings: Double = 0
    @Published var savingsRate: Double = 0
    @Published var budgetRemaining: Double = 0
    @Published var recentTransactions: [Transaction] = []
    @Published var accountCount: Int = 0
    @Published var overBudgetCategories: [Budget] = []
    @Published var topGoals: [Goal] = []

    private let dataService = DataService.shared

    init() {
        loadData()
    }

    func loadData() {
        wealthScore = dataService.getWealthScore()
        totalNetWorth = dataService.getTotalNetWorth()
        monthlyIncome = dataService.getMonthlyIncome()
        monthlyExpenses = dataService.getMonthlyExpenses()
        monthlySavings = dataService.getMonthlySavings()
        savingsRate = monthlyIncome > 0 ? (monthlySavings / monthlyIncome) * 100 : 0
        recentTransactions = dataService.getRecentTransactions(limit: 5)
        accountCount = dataService.getAccounts().count

        let budgets = dataService.getBudgets()
        overBudgetCategories = budgets.filter { $0.isOverBudget }

        let totalBudgetLimit = budgets.reduce(0) { $0 + $1.monthlyLimit }
        let totalBudgetSpent = budgets.reduce(0) { $0 + $1.spent }
        budgetRemaining = max(0, totalBudgetLimit - totalBudgetSpent)

        topGoals = Array(dataService.getGoals().prefix(3))
    }

    func refresh() {
        loadData()
    }

    var wealthScoreColor: String {
        switch wealthScore {
        case 80...100: return "#34C759"
        case 60..<80: return "#007AFF"
        case 40..<60: return "#FF9500"
        default: return "#FF3B30"
        }
    }

    var wealthScoreMessage: String {
        switch wealthScore {
        case 80...100: return "Excellent!"
        case 60..<80: return "Good"
        case 40..<60: return "Fair"
        default: return "Needs Work"
        }
    }

    var budgetHealthMessage: String {
        if overBudgetCategories.isEmpty {
            return "All budgets on track"
        } else {
            return "\(overBudgetCategories.count) categories over budget"
        }
    }
}
