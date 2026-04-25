import XCTest

final class iPadScreenshotTests: XCTestCase {

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
        try? data.write(to: URL(fileURLWithPath: "/tmp/iPad_\(name).png"))
    }

    func test01_Dashboard() throws {
        ss("01_dashboard")
        XCTAssertTrue(app.tabBars.buttons["Dashboard"].exists)
    }

    func test02_Transactions() throws {
        app.tabBars.buttons["Transactions"].tap()
        ss("02_transactions")
        XCTAssertTrue(app.navigationBars["Transactions"].exists)
    }

    func test03_Budget() throws {
        app.tabBars.buttons["Budget"].tap()
        ss("03_budget")
        XCTAssertTrue(app.navigationBars["Budget"].exists)
    }

    func test04_Goals() throws {
        app.tabBars.buttons["Goals"].tap()
        ss("04_goals")
        XCTAssertTrue(app.navigationBars["Goals"].exists)
    }

    func test05_Settings() throws {
        app.tabBars.buttons["Settings"].tap()
        ss("05_settings")
        XCTAssertTrue(app.navigationBars["Settings"].exists)
    }

    func test06_AddTransaction() throws {
        app.tabBars.buttons["Transactions"].tap()
        ss("06_before_add")
        app.navigationBars.buttons.element(boundBy: 0).tap()
        ss("07_add_transaction")
    }

    func test08_BudgetRule() throws {
        app.tabBars.buttons["Budget"].tap()
        ss("08_budget_rule")
    }

    func test09_GoalsGrid() throws {
        app.tabBars.buttons["Goals"].tap()
        ss("09_goals_grid")
    }

    func test10_SettingsDetail() throws {
        app.tabBars.buttons["Settings"].tap()
        ss("10_settings_detail")
    }
}
