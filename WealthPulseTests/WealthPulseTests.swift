import XCTest
@testable import WealthPulse

final class WealthPulseTests: XCTestCase {

    func testTransactionType() {
        XCTAssertEqual(TransactionType.allCases.count, 2)
        XCTAssertEqual(TransactionType.income.rawValue, "Income")
        XCTAssertEqual(TransactionType.expense.rawValue, "Expense")
    }

    func testTransactionCategory() {
        XCTAssertGreaterThan(TransactionCategory.allCases.count, 10)
        XCTAssertEqual(TransactionCategory.food.icon, "fork.knife")
        XCTAssertEqual(TransactionCategory.salary.icon, "dollarsign.circle.fill")
    }

    func testAccountType() {
        XCTAssertEqual(AccountType.allCases.count, 5)
        XCTAssertEqual(AccountType.checking.rawValue, "Checking")
        XCTAssertEqual(AccountType.savings.rawValue, "Savings")
    }

    func testBudgetRule() {
        XCTAssertEqual(BudgetRule.allCases.count, 3)
        XCTAssertEqual(BudgetRule.rule50_30_20.rawValue, "50/30/20 Rule")
    }

    func testGoalType() {
        XCTAssertEqual(GoalType.allCases.count, 4)
        XCTAssertEqual(GoalType.emergencyFund.rawValue, "Emergency Fund")
        XCTAssertEqual(GoalType.retirement.rawValue, "Retirement")
    }

    func testInvestmentType() {
        XCTAssertEqual(InvestmentType.allCases.count, 5)
        XCTAssertEqual(InvestmentType.stock.rawValue, "Stock")
        XCTAssertEqual(InvestmentType.bond.rawValue, "Bond")
    }

    func testSubscriptionFrequency() {
        XCTAssertEqual(SubscriptionFrequency.allCases.count, 4)
        XCTAssertEqual(SubscriptionFrequency.monthly.rawValue, "Monthly")
    }
}