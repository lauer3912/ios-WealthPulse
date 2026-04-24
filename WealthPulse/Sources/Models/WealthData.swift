import Foundation

final class WealthData: Codable {
    static let shared = WealthData()

    var accounts: [Account] = []
    var transactions: [Transaction] = []
    var budgets: [Budget] = []
    var goals: [Goal] = []
    var investments: [Investment] = []
    var taxInfos: [TaxInfo] = []
    var subscription: Subscription?
    var budgetRule: BudgetRule = BudgetRule()

    var settings: AppSettings = AppSettings()

    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private enum CodingKeys: String, CodingKey {
        case accounts, transactions, budgets, goals, investments, taxInfos, subscription, budgetRule, settings
    }

    private init() {
        load()
        if accounts.isEmpty {
            setupDefaultData()
        }
    }

    func load() {
        if let data = defaults.data(forKey: "WealthPulseData") {
            do {
                let decoded = try decoder.decode(WealthData.self, from: data)
                self.accounts = decoded.accounts
                self.transactions = decoded.transactions
                self.budgets = decoded.budgets
                self.goals = decoded.goals
                self.investments = decoded.investments
                self.taxInfos = decoded.taxInfos
                self.subscription = decoded.subscription
                self.budgetRule = decoded.budgetRule
                self.settings = decoded.settings
            } catch {
                print("Failed to decode WealthData: \(error)")
            }
        }
    }

    func save() {
        do {
            let data = try encoder.encode(self)
            defaults.set(data, forKey: "WealthPulseData")
        } catch {
            print("Failed to encode WealthData: \(error)")
        }
    }

    private func setupDefaultData() {
        let checking = Account(name: "Main Checking", type: .checking, balance: 5420.00, currency: "USD", color: "#007AFF")
        let savings = Account(name: "Emergency Fund", type: .savings, balance: 12500.00, currency: "USD", color: "#34C759")
        let creditCard = Account(name: "Chase Sapphire", type: .creditCard, balance: -1240.50, currency: "USD", color: "#FF2D55")
        accounts = [checking, savings, creditCard]

        let grocery = Budget(category: .food, monthlyLimit: 600)
        let transport = Budget(category: .transport, monthlyLimit: 300)
        let entertainment = Budget(category: .entertainment, monthlyLimit: 200)
        let shopping = Budget(category: .shopping, monthlyLimit: 400)
        let bills = Budget(category: .bills, monthlyLimit: 800)
        budgets = [grocery, transport, entertainment, shopping, bills]

        let emergencyFund = Goal(name: "Emergency Fund", targetAmount: 15000, currentAmount: 12500, deadline: Calendar.current.date(byAdding: .month, value: 3, to: Date()), icon: .piggy, color: "#34C759")
        let vacation = Goal(name: "Summer Vacation", targetAmount: 3500, currentAmount: 1200, deadline: Calendar.current.date(byAdding: .month, value: 6, to: Date()), icon: .airplaneDeparture, color: "#007AFF")
        goals = [emergencyFund, vacation]

        budgetRule = BudgetRule()
        save()
    }

    // MARK: - Account Operations

    func addAccount(_ account: Account) {
        accounts.append(account)
        save()
    }

    func updateAccount(_ account: Account) {
        if let index = accounts.firstIndex(where: { $0.id == account.id }) {
            accounts[index] = account
            save()
        }
    }

    func deleteAccount(_ account: Account) {
        accounts.removeAll { $0.id == account.id }
        transactions.removeAll { $0.accountId == account.id }
        investments.removeAll { $0.accountId == account.id }
        save()
    }

    // MARK: - Transaction Operations

    func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
        if let accountId = transaction.accountId, let index = accounts.firstIndex(where: { $0.id == accountId }) {
            if transaction.type == .income {
                accounts[index].balance += transaction.amount
            } else {
                accounts[index].balance -= transaction.amount
            }
        }
        updateBudgetSpending(for: transaction)
        save()
    }

    func updateTransaction(_ transaction: Transaction) {
        if let index = transactions.firstIndex(where: { $0.id == transaction.id }) {
            transactions[index] = transaction
            save()
        }
    }

    func deleteTransaction(_ transaction: Transaction) {
        transactions.removeAll { $0.id == transaction.id }
        save()
    }

    private func updateBudgetSpending(for transaction: Transaction) {
        guard transaction.type == .expense else { return }
        if let index = budgets.firstIndex(where: { $0.category == transaction.category }) {
            budgets[index].spent += transaction.amount
        }
    }

    // MARK: - Budget Operations

    func addBudget(_ budget: Budget) {
        budgets.append(budget)
        save()
    }

    func updateBudget(_ budget: Budget) {
        if let index = budgets.firstIndex(where: { $0.id == budget.id }) {
            budgets[index] = budget
            save()
        }
    }

    func deleteBudget(_ budget: Budget) {
        budgets.removeAll { $0.id == budget.id }
        save()
    }

    func resetBudgetsForNewMonth() {
        for i in 0..<budgets.count {
            budgets[i].spent = 0
        }
        save()
    }

    // MARK: - Goal Operations

    func addGoal(_ goal: Goal) {
        goals.append(goal)
        save()
    }

    func updateGoal(_ goal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index] = goal
            save()
        }
    }

    func deleteGoal(_ goal: Goal) {
        goals.removeAll { $0.id == goal.id }
        save()
    }

    func contributeToGoal(_ goalId: UUID, amount: Double) {
        if let index = goals.firstIndex(where: { $0.id == goalId }) {
            goals[index].currentAmount += amount
            if goals[index].currentAmount >= goals[index].targetAmount {
                goals[index].currentAmount = goals[index].targetAmount
            }
            save()
        }
    }

    // MARK: - Investment Operations

    func addInvestment(_ investment: Investment) {
        investments.append(investment)
        save()
    }

    func updateInvestment(_ investment: Investment) {
        if let index = investments.firstIndex(where: { $0.id == investment.id }) {
            investments[index] = investment
            save()
        }
    }

    func deleteInvestment(_ investment: Investment) {
        investments.removeAll { $0.id == investment.id }
        save()
    }

    // MARK: - Summary Calculations

    var totalNetWorth: Double {
        return accounts.reduce(0) { $0 + $1.balance }
    }

    var totalMonthlyIncome: Double {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
        return transactions
            .filter { $0.type == .income && $0.date >= startOfMonth }
            .reduce(0) { $0 + $1.amount }
    }

    var totalMonthlyExpenses: Double {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
        return transactions
            .filter { $0.type == .expense && $0.date >= startOfMonth }
            .reduce(0) { $0 + $1.amount }
    }

    var monthlySavings: Double {
        return totalMonthlyIncome - totalMonthlyExpenses
    }

    var savingsRate: Double {
        guard totalMonthlyIncome > 0 else { return 0 }
        return (monthlySavings / totalMonthlyIncome) * 100
    }

    var wealthScore: Int {
        var score = 50
        if savingsRate >= 20 { score += 20 }
        else if savingsRate >= 10 { score += 10 }
        if totalNetWorth > 10000 { score += 10 }
        if totalNetWorth > 50000 { score += 10 }
        if !investments.isEmpty { score += 10 }
        let budgetCompliance = budgets.filter { !$0.isOverBudget }.count
        score += (budgetCompliance * 10) / max(1, budgets.count)
        return min(100, score)
    }

    // MARK: - Filtered Transactions

    func transactions(for month: Date) -> [Transaction] {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month))!
        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
        return transactions.filter { $0.date >= startOfMonth && $0.date <= endOfMonth }
    }

    func transactions(for account: Account) -> [Transaction] {
        return transactions.filter { $0.accountId == account.id }
    }
}

struct AppSettings: Codable {
    var theme: AppTheme = .system
    var currency: String = "USD"
    var currencySymbol: String = "$"
    var biometricEnabled: Bool = false
    var notificationsEnabled: Bool = true
    var privacyModeEnabled: Bool = false
    var firstLaunchDate: Date = Date()
    var lastBackupDate: Date?

    enum AppTheme: String, Codable, CaseIterable {
        case system = "System"
        case light = "Light"
        case dark = "Dark"
    }
}
