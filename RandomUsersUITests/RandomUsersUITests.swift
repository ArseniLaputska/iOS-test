//
//  RandomUsersUITests.swift
//  RandomUsersUITests
//
//  Created by Alejandro Guerra, DSpot on 9/13/21.
//

import XCTest

final class RandomUsersUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
    }

    func testTableLoadsFirst50() {
        let firstCell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))

        XCTAssertGreaterThanOrEqual(app.tables.cells.count, 50)
    }

    func testInfiniteScrollAddsMoreCells() {
        let table = app.tables.element
        let startCount = table.cells.count

        table.swipeUp(velocity: .fast)
        table.swipeUp(velocity: .fast)

        expectation(
            for: NSPredicate(format: "count > %d", startCount),
            evaluatedWith: table.cells,
            handler: nil
        )
        
        waitForExpectations(timeout: 5)
    }
}
