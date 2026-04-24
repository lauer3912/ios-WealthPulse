import Foundation

final class DataService {
    static let shared = DataService()

    private let wealthData = WealthData.shared

    private init() {}

    // MARK: - Account Operations

    func createAccount(name: String, type: AccountType, balance: Double, currency: String = "USD", color: String = "#34C759") -> Account {
        let account = Account(name: name, type: type, balance: balance, currency: currency, color: color)
        wealthData.addAccount(account)
        return account
    }

    func getAccounts() -> [Account] {
        return wealthData.accounts
    }

    func getAccount(by id: UUID) -> Account? {
        return wealthData.accounts.first { $0.id == id }
    }

    func updateAccount(_ account: Account) {
        wealthData.updateAccount(account)
    }

    func deleteAccount(_ account: Account) {
        wealthData.deleteAccount(account)
    }

    // MARK: - Transaction Operations

    func createTransaction(amount: Double, type: TransactionType, category: TransactionCategory, note: String = "", date: Date = Date(), accountId: UUID? = nil, isRecurring: Bool = false, recurringInterval: String? = nil) -> Transaction {
        let transaction = Transaction(amount: amount, type: type, category: category, note: note, date: date, accountId: accountId, isRecurring: isRecurring, recurringInterval: recurringInterval)
        wealthData.addTransaction(transaction)
        return transaction
    }

    func getTransactions() -> [Transaction] {
        return wealthData.transactions.sorted { $0.date > $1.date }
    }

    func getTransactions(for month: Date) -> [Transaction] {
        return wealthData.transactions(for: month).sorted { $0.date > $1.date }
    }

    func getTransactions(for account: Account) -> [Transaction] {
        return wealthData.transactions(for: account).sorted { $0.date > $1.date }
    }

    func getRecentTransactions(limit: Int = 5) -> [Transaction] {
        return Array(getTransactions().prefix(limit))
    }

    func updateTransaction(_ transaction: Transaction) {
        wealthData.updateTransaction(transaction)
    }

    func deleteTransaction(_ transaction: Transaction) {
        wealthData.deleteTransaction(transaction)
    }

    // MARK: - Budget Operations

    func createBudget(category: TransactionCategory, monthlyLimit: Double) -> Budget {
        let budget = Budget(category: category, monthlyLimit: monthlyLimit)
        wealthData.addBudget(budget)
        return budget
    }

    func getBudgets() -> [Budget] {
        return wealthData.budgets
    }

    func getBudget(for category: TransactionCategory) -> Budget? {
        return wealthData.budgets.first { $0.category == category }
    }

    func updateBudget(_ budget: Budget) {
        wealthData.updateBudget(budget)
    }

    func deleteBudget(_ budget: Budget) {
        wealthData.deleteBudget(budget)
    }

    func resetBudgetsForNewMonth() {
        wealthData.resetBudgetsForNewMonth()
    }

    // MARK: - Goal Operations

    func createGoal(name: String, targetAmount: Double, deadline: Date?, icon: GoalIcon, color: String = "#34C759") -> Goal {
        let goal = Goal(name: name, targetAmount: targetAmount, deadline: deadline, icon: icon, color: color)
        wealthData.addGoal(goal)
        return goal
    }

    func getGoals() -> [Goal] {
        return wealthData.goals
    }

    func getGoal(by id: UUID) -> Goal? {
        return wealthData.goals.first { $0.id == id }
    }

    func updateGoal(_ goal: Goal) {
        wealthData.updateGoal(goal)
    }

    func deleteGoal(_ goal: Goal) {
        wealthData.deleteGoal(goal)
    }

    func contributeToGoal(_ goalId: UUID, amount: Double) {
        wealthData.contributeToGoal(goalId, amount: amount)
    }

    // MARK: - Investment Operations

    func createInvestment(symbol: String, name: String, type: InvestmentType, shares: Double, purchasePrice: Double, currentPrice: Double, accountId: UUID? = nil) -> Investment {
        let investment = Investment(symbol: symbol, name: name, type: type, shares: shares, purchasePrice: purchasePrice, currentPrice: currentPrice, accountId: accountId)
        wealthData.addInvestment(investment)
        return investment
    }

    func getInvestments() -> [Investment] {
        return wealthData.investments
    }

    func updateInvestment(_ investment: Investment) {
        wealthData.updateInvestment(investment)
    }

    func deleteInvestment(_ investment: Investment) {
        wealthData.deleteInvestment(investment)
    }

    // MARK: - Summary Data

    func getTotalNetWorth() -> Double {
        return wealthData.totalNetWorth
    }

    func getMonthlyIncome() -> Double {
        return wealthData.totalMonthlyIncome
    }

    func getMonthlyExpenses() -> Double {
        return wealthData.totalMonthlyExpenses
    }

    func getMonthlySavings() -> Double {
        return wealthData.monthlySavings
    }

    func getWealthScore() -> Int {
        return wealthData.wealthScore
    }

    func getBudgetRule() -> BudgetRule {
        return wealthData.budgetRule
    }

    // MARK: - Settings

    func getSettings() -> AppSettings {
        return wealthData.settings
    }

    func updateSettings(_ settings: AppSettings) {
        wealthData.settings = settings
        wealthData.save()
    }
}
