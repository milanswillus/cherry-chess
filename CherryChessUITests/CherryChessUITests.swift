import XCTest

/// Drives the app through its five main tabs and captures an App Store
/// screenshot on each. Run via `fastlane screenshots` (fastlane `snapshot`),
/// which builds this target and iterates over the configured devices/languages.
@MainActor
final class CherryChessUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testCaptureScreenshots() throws {
        let app = XCUIApplication()
        setupSnapshot(app)

        // Populate a clean demo state (skips onboarding, seeds games).
        app.launchArguments += ["--uitest"]

        // The app selects its language from the `appLanguage` user default rather
        // than from `-AppleLanguages`, so mirror snapshot's language into it.
        if let idx = app.launchArguments.firstIndex(of: "-AppleLanguages"),
           idx + 1 < app.launchArguments.count {
            let raw = app.launchArguments[idx + 1]                      // e.g. "(de-DE)"
            let code = raw.trimmingCharacters(in: CharacterSet(charactersIn: "()\""))
                .split(separator: "-").first.map(String.init) ?? "en"
            app.launchArguments += ["-appLanguage", code]
        }

        app.launch()

        // 1. Game setup
        snapshot("01Game")

        // 2. History (seeded games + win-rate stats)
        selectTab(app, 1)
        snapshot("02History")

        // 3. Openings / Training (grid of mini boards)
        selectTab(app, 2)
        snapshot("03Openings")

        // 4. Analysis setup
        selectTab(app, 3)
        snapshot("04Analysis")

        // 5. Profile (challenge stats + trend charts)
        selectTab(app, 4)
        snapshot("05Profile")

        // 6. A real chess board — analysis mode plays both sides (no engine
        //    opponent), so we tap out a short opening and capture the position.
        captureBoard(app)
    }

    /// Opens the Analysis board (starting position) and snapshots it so the
    /// screenshot set shows an actual chess board.
    private func captureBoard(_ app: XCUIApplication) {
        selectTab(app, 3)

        let start = app.buttons["startAnalysis"]
        XCTAssertTrue(start.waitForExistence(timeout: 10), "Start Analysis button not found")
        start.tap()

        // Let the board appear and settle before capturing.
        Thread.sleep(forTimeInterval: 2.5)
        snapshot("00Board")
    }

    /// Taps the custom tab-bar button with the given index and waits for it.
    private func selectTab(_ app: XCUIApplication, _ index: Int) {
        let button = app.buttons["tab_\(index)"]
        XCTAssertTrue(button.waitForExistence(timeout: 10), "Tab \(index) button not found")
        button.tap()
    }
}
