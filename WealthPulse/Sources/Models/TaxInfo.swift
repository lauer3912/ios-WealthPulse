import Foundation

enum FilingStatus: String, Codable, CaseIterable {
    case single = "Single"
    case marriedFilingJointly = "Married Filing Jointly"
    case marriedFilingSeparately = "Married Filing Separately"
    case headOfHousehold = "Head of Household"
    case qualifyingWidow = "Qualifying Widow(er)"

    var abbreviation: String {
        switch self {
        case .single: return "S"
        case .marriedFilingJointly: return "MFJ"
        case .marriedFilingSeparately: return "MFS"
        case .headOfHousehold: return "HOH"
        case .qualifyingWidow: return "QW"
        }
    }
}

struct TaxInfo: Codable, Identifiable, Equatable {
    let id: UUID
    var year: Int
    var filingStatus: FilingStatus
    var grossIncome: Double
    var adjustedGrossIncome: Double
    var federalTaxOwed: Double
    var stateTaxOwed: Double
    var socialSecurity: Double
    var medicare: Double
    var totalTax: Double
    var effectiveTaxRate: Double
    var netIncome: Double
    var quarterlyPayments: [QuarterlyPayment]
    var w2Info: W2Info?
    var form1099Info: [Form1099Info]
    var notes: String
    var createdAt: Date

    init(id: UUID = UUID(), year: Int = Calendar.current.component(.year, from: Date())) {
        self.id = id
        self.year = year
        self.filingStatus = .single
        self.grossIncome = 0
        self.adjustedGrossIncome = 0
        self.federalTaxOwed = 0
        self.stateTaxOwed = 0
        self.socialSecurity = 0
        self.medicare = 0
        self.totalTax = 0
        self.effectiveTaxRate = 0
        self.netIncome = 0
        self.quarterlyPayments = []
        self.w2Info = nil
        self.form1099Info = []
        self.notes = ""
        self.createdAt = Date()
    }

    var totalQuarterlyPayments: Double {
        return quarterlyPayments.reduce(0) { $0 + $1.amount }
    }

    var remainingTaxDue: Double {
        return max(0, totalTax - totalQuarterlyPayments)
    }

    var quarterlyPaymentDue: Double {
        return totalTax / 4
    }

    mutating func calculateTaxes() {
        totalTax = federalTaxOwed + stateTaxOwed + socialSecurity + medicare
        effectiveTaxRate = grossIncome > 0 ? (totalTax / grossIncome) * 100 : 0
        netIncome = grossIncome - totalTax
    }
}

struct QuarterlyPayment: Codable, Identifiable, Equatable {
    let id: UUID
    var quarter: Int
    var dueDate: Date
    var amount: Double
    var isPaid: Bool
    var paidDate: Date?
    var notes: String

    init(id: UUID = UUID(), quarter: Int, dueDate: Date, amount: Double = 0, isPaid: Bool = false, paidDate: Date? = nil, notes: String = "") {
        self.id = id
        self.quarter = quarter
        self.dueDate = dueDate
        self.amount = amount
        self.isPaid = isPaid
        self.paidDate = paidDate
        self.notes = notes
    }

    var isOverdue: Bool {
        return !isPaid && Date() > dueDate
    }
}

struct W2Info: Codable, Equatable {
    var employerName: String
    var employerEIN: String
    var wages: Double
    var federalTaxWithheld: Double
    var stateTaxWithheld: Double
    var socialSecurityWithheld: Double
    var medicareWithheld: Double
}

struct Form1099Info: Codable, Identifiable, Equatable {
    let id: UUID
    var payer: String
    var type: String
    var amount: Double

    init(id: UUID = UUID(), payer: String, type: String, amount: Double) {
        self.id = id
        self.payer = payer
        self.type = type
        self.amount = amount
    }
}
