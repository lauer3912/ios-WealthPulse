import XCTest

final class iPadScreenshotTests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = true
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

    func testScreenshot() throws {
        ss("01_dashboard")
        XCTAssertTrue(app.tabBars.buttons["Dashboard"].exists)
    }
}
