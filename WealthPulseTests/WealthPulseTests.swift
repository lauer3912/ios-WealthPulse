import XCTest

final class WealthPulseTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here
    }

    override func tearDownWithError() throws {
        // Put teardown code here
    }

    func testCurrencyFormatting() throws {
        let amount = 1234.56
        let formatted = amount.currencyFormatted
        XCTAssertFalse(formatted.isEmpty)
    }

    func testDateFormatting() throws {
        let date = Date()
        let formatted = date.formatted()
        XCTAssertFalse(formatted.isEmpty)
    }

    func testAccountTypes() throws {
        let types = AccountType.allCases
        XCTAssertTrue(types.count > 0)
        XCTAssertEqual(types.first, .checking)
    }

    func testTransactionCategories() throws {
        let categories = TransactionCategory.allCases
        XCTAssertTrue(categories.count > 0)
    }

    func testGoalIcons() throws {
        let icons = GoalIcon.allCases
        XCTAssertTrue(icons.count > 0)
    }

    func testSubscriptionTiers() throws {
        let tiers = SubscriptionTier.allCases
        XCTAssertTrue(tiers.count == 2)
    }
}
