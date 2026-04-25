import XCTest
@testable import WealthPulse

final class WealthPulseTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here
    }

    override func tearDownWithError() throws {
        // Put teardown code here
    }

    func testAccountCreation() throws {
        let account = Account(name: "Test Checking", type: .checking, balance: 1000.0)
        XCTAssertEqual(account.name, "Test Checking")
        XCTAssertEqual(account.balance, 1000.0)
        XCTAssertEqual(account.type, .checking)
    }

    func testTransactionCreation() throws {
        let transaction = Transaction(amount: 50.0, type: .expense, category: .food)
        XCTAssertEqual(transaction.amount, 50.0)
        XCTAssertEqual(transaction.type, .expense)
        XCTAssertEqual(transaction.category, .food)
    }

    func testBudgetCalculation() throws {
        let budget = Budget(category: .food, monthlyLimit: 500)
        XCTAssertEqual(budget.monthlyLimit, 500)
        XCTAssertEqual(budget.spent, 0)
        XCTAssertEqual(budget.remaining, 500)
    }

    func testGoalProgress() throws {
        let goal = Goal(name: "Emergency Fund", targetAmount: 10000, currentAmount: 5000)
        XCTAssertEqual(goal.progress, 0.5)
        XCTAssertEqual(goal.remainingAmount, 5000)
        XCTAssertFalse(goal.isCompleted)
    }

    func testWealthDataSingleton() throws {
        let data = WealthData.shared
        XCTAssertNotNil(data.accounts)
        XCTAssertNotNil(data.transactions)
        XCTAssertNotNil(data.budgets)
        XCTAssertNotNil(data.goals)
    }

    func testCurrencyFormatting() throws {
        let amount = 1234.56
        let formatted = amount.currencyFormatted
        XCTAssertTrue(formatted.contains("1,234") || formatted.contains("1234"))
    }

    func testDateFormatting() throws {
        let date = Date()
        let formatted = date.formatted()
        XCTAssertFalse(formatted.isEmpty)
    }
}
