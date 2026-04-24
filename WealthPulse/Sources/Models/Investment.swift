import Foundation

enum InvestmentType: String, Codable, CaseIterable {
    case stock = "Stock"
    case etf = "ETF"
    case mutualFund = "Mutual Fund"
    case bond = "Bond"
    case crypto = "Cryptocurrency"
    case other = "Other"

    var icon: String {
        switch self {
        case .stock: return "chart.line.uptrend.xyaxis"
        case .etf: return "chart.pie.fill"
        case .mutualFund: return "chart.bar.fill"
        case .bond: return "doc.text.fill"
        case .crypto: return "bitcoinsign.circle.fill"
        case .other: return "folder.fill"
        }
    }
}

struct Investment: Codable, Identifiable, Equatable {
    let id: UUID
    var symbol: String
    var name: String
    var type: InvestmentType
    var shares: Double
    var purchasePrice: Double
    var currentPrice: Double
    var purchaseDate: Date
    var accountId: UUID?
    var notes: String
    var createdAt: Date

    init(id: UUID = UUID(), symbol: String, name: String, type: InvestmentType, shares: Double, purchasePrice: Double, currentPrice: Double = 0, purchaseDate: Date = Date(), accountId: UUID? = nil, notes: String = "") {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.type = type
        self.shares = shares
        self.purchasePrice = purchasePrice
        self.currentPrice = currentPrice > 0 ? currentPrice : purchasePrice
        self.purchaseDate = purchaseDate
        self.accountId = accountId
        self.notes = notes
        self.createdAt = Date()
    }

    var totalCost: Double {
        return shares * purchasePrice
    }

    var currentValue: Double {
        return shares * currentPrice
    }

    var totalReturn: Double {
        return currentValue - totalCost
    }

    var percentReturn: Double {
        guard totalCost > 0 else { return 0 }
        return (totalReturn / totalCost) * 100
    }

    var isProfit: Bool {
        return totalReturn >= 0
    }

    var dayChange: Double {
        return 0
    }

    var dayChangePercent: Double {
        return 0
    }
}

struct InvestmentAccount: Codable, Identifiable, Equatable {
    let id: UUID
    var name: String
    var type: AccountType
    var institutions: String
    var balance: Double
    var investments: [Investment]
    var createdAt: Date

    init(id: UUID = UUID(), name: String, type: AccountType = .investment, institutions: String = "", balance: Double = 0, investments: [Investment] = []) {
        self.id = id
        self.name = name
        self.type = type
        self.institutions = institutions
        self.balance = balance
        self.investments = investments
        self.createdAt = Date()
    }

    var totalValue: Double {
        return investments.reduce(0) { $0 + $1.currentValue }
    }

    var totalReturn: Double {
        return investments.reduce(0) { $0 + $1.totalReturn }
    }
}
