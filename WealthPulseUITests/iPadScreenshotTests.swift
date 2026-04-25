import XCTest

final class iPadScreenshotTests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = true
        app = XCUIApplication()
        app.launchArguments = ["snapshots"]
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func ss(_ name: String) {
        let data = app.windows.firstMatch.screenshot().pngRepresentation
        try? data.write(to: URL(fileURLWithPath: "/tmp/iPad_\(name).png"))
    }

    func testDashboard() throws {
        ss("01_dashboard")
    }

    func testTransactions() throws {
        if app.tabBars.buttons["Transactions"].exists {
            app.tabBars.buttons["Transactions"].tap()
        }
        ss("02_transactions")
    }

    func testBudget() throws {
        if app.tabBars.buttons["Budget"].exists {
            app.tabBars.buttons["Budget"].tap()
        }
        ss("03_budget")
    }

    func testGoals() throws {
        if app.tabBars.buttons["Goals"].exists {
            app.tabBars.buttons["Goals"].tap()
        }
        ss("04_goals")
    }

    func testSettings() throws {
        if app.tabBars.buttons["Settings"].exists {
            app.tabBars.buttons["Settings"].tap()
        }
        ss("05_settings")
    }
}