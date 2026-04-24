import Foundation
import Combine

enum TransactionFilter: String, CaseIterable {
    case all = "All"
    case income = "Income"
    case expense = "Expense"
}

final class TransactionsViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var filteredTransactions: [Transaction] = []
    @Published var groupedTransactions: [(date: Date, transactions: [Transaction])] = []
    @Published var selectedFilter: TransactionFilter = .all
    @Published var searchText: String = ""
    @Published var totalIncome: Double = 0
    @Published var totalExpense: Double = 0
    @Published var netAmount: Double = 0

    private let dataService = DataService.shared

    init() {
        loadData()
    }

    func loadData() {
        transactions = dataService.getTransactions()
        applyFilter()
    }

    func applyFilter() {
        var result = transactions

        switch selectedFilter {
        case .all:
            break
        case .income:
            result = result.filter { $0.type == .income }
        case .expense:
            result = result.filter { $0.type == .expense }
        }

        if !searchText.isEmpty {
            result = result.filter {
                $0.category.rawValue.localizedCaseInsensitiveContains(searchText) ||
                $0.note.localizedCaseInsensitiveContains(searchText)
            }
        }

        filteredTransactions = result
        groupTransactionsByDate()
        calculateTotals()
    }

    private func groupTransactionsByDate() {
        let grouped = Dictionary(grouping: filteredTransactions) { transaction in
            Calendar.current.startOfDay(for: transaction.date)
        }

        groupedTransactions = grouped
            .map { (date: $0.key, transactions: $0.value.sorted { $0.date > $1.date }) }
            .sorted { $0.date > $1.date }
    }

    private func calculateTotals() {
        totalIncome = filteredTransactions.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
        totalExpense = filteredTransactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
        netAmount = totalIncome - totalExpense
    }

    func addTransaction(amount: Double, type: TransactionType, category: TransactionCategory, note: String = "", date: Date = Date(), accountId: UUID? = nil, isRecurring: Bool = false, recurringInterval: String? = nil) {
        _ = dataService.createTransaction(amount: amount, type: type, category: category, note: note, date: date, accountId: accountId, isRecurring: isRecurring, recurringInterval: recurringInterval)
        loadData()
    }

    func deleteTransaction(_ transaction: Transaction) {
        dataService.deleteTransaction(transaction)
        loadData()
    }

    func deleteTransaction(at indexPath: IndexPath) {
        guard indexPath.section < groupedTransactions.count,
              indexPath.row < groupedTransactions[indexPath.section].transactions.count else { return }

        let transaction = groupedTransactions[indexPath.section].transactions[indexPath.row]
        deleteTransaction(transaction)
    }

    var accounts: [Account] {
        return dataService.getAccounts()
    }

    var categoriesForIncome: [TransactionCategory] {
        return [.salary, .freelance, .investment, .gift, .refund, .otherIncome]
    }

    var categoriesForExpense: [TransactionCategory] {
        return [.food, .transport, .shopping, .entertainment, .bills, .health, .housing, .education, .travel, .subscription, .otherExpense]
    }
}
