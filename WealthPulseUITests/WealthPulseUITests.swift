import XCTest

final class WealthPulseUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func ss(_ name: String) {
        let data = app.windows.firstMatch.screenshot().pngRepresentation
        try? data.write(to: URL(fileURLWithPath: "/tmp/WealthPulse_\(name).png"))
    }

    func testDashboardLaunch() throws {
        ss("01_dashboard")
        XCTAssertTrue(app.tabBars.buttons["Dashboard"].exists)
    }

    func testNavigateToTransactions() throws {
        app.tabBars.buttons["Transactions"].tap()
        ss("02_transactions")
        XCTAssertTrue(app.navigationBars["Transactions"].exists)
    }

    func testNavigateToBudget() throws {
        app.tabBars.buttons["Budget"].tap()
        ss("03_budget")
        XCTAssertTrue(app.navigationBars["Budget"].exists)
    }

    func testNavigateToGoals() throws {
        app.tabBars.buttons["Goals"].tap()
        ss("04_goals")
        XCTAssertTrue(app.navigationBars["Goals"].exists)
    }

    func testNavigateToSettings() throws {
        app.tabBars.buttons["Settings"].tap()
        ss("05_settings")
        XCTAssertTrue(app.navigationBars["Settings"].exists)
    }

    func testAddTransaction() throws {
        app.tabBars.buttons["Transactions"].tap()
        ss("06_before_add_transaction")

        app.navigationBars.buttons.element(boundBy: 0).tap()
        ss("07_add_transaction_modal")

        let amountField = app.textFields.firstMatch
        amountField.tap()
        amountField.typeText("50.00")

        app.buttons["Save Transaction"].tap()
        ss("08_after_add_transaction")
    }

    func testBudgetRuleCard() throws {
        app.tabBars.buttons["Budget"].tap()
        ss("09_budget_rule")

        let ruleCard = app.staticTexts["50/30/20 Rule"]
        XCTAssertTrue(ruleCard.waitForExistence(timeout: 5))
    }

    func testGoalCreation() throws {
        app.tabBars.buttons["Goals"].tap()
        ss("10_goals_before")

        app.navigationBars.buttons.element(boundBy: 0).tap()
        ss("11_add_goal_modal")

        let nameField = app.textFields.firstMatch
        nameField.tap()
        nameField.typeText("Test Goal")

        app.buttons["Create Goal"].tap()
        ss("12_goals_after")
    }

    func testSettingsThemeToggle() throws {
        app.tabBars.buttons["Settings"].tap()
        ss("13_settings_before")

        // Navigate to Preferences section
        let cells = app.tables.cells
        XCTAssertTrue(cells.count > 0, "Settings should have cells")
        ss("14_settings_preferences")
    }

    func testLaunchPerformance() throws {
        if #available(iOS 13.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
