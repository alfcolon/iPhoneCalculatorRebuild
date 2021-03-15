//
//  ContinueArithmeticBetweenCalculators.swift
//  iPhoneCalculatorRebuildUITests
//
//  Created by Alfredo Colon on 3/14/21.
//  Copyright © 2021 Alfredo Colon. All rights reserved.
//

import XCTest

class ContinueArithmeticBetweenCalculators: XCTestCase {

	func testOperatorMaintainsSelectedStateBetweenRotations() {
		let app = XCUIApplication()
		app.launch()
		XCUIDevice.shared.orientation = .portrait

		let collectionView = app.collectionViews.firstMatch
		XCTAssertTrue(collectionView.waitForExistence(timeout: 1))

		var deselectedCells: XCUIElementQuery { return collectionView.cells.matching(identifier: "deselected") }
		var selectedCells: XCUIElementQuery { return collectionView.cells.matching(identifier: "selected") }

		// Check initial count of deselected and selected cells
		XCTAssertTrue(deselectedCells.count == 19)
		XCTAssertTrue(selectedCells.count == 0)

		// Tap Divide
		var divide = deselectedCells.allElementsBoundByIndex[3]
		divide.tap()

		// Make sure de/selected cell count was updated
		XCTAssertTrue(deselectedCells.count == 18)
		XCTAssertTrue(selectedCells.count == 1)

		// Rotate back to landscape
		XCUIDevice.shared.orientation = .landscapeLeft

		// Make sure selected cell count is 2
		XCTAssertTrue(deselectedCells.count == 48)
		XCTAssertTrue(selectedCells.count == 1)

		// Make sure selected cell is divide
		divide = selectedCells.firstMatch
		XCTAssertTrue(divide.label == "divide")
	}
	
	func test2ndCellMaintainsItsSelectedStateBetweenRotations() {
		let app = XCUIApplication()
		app.launch()
		XCUIDevice.shared.orientation = .portrait
		
		let collectionView = app.collectionViews.firstMatch
		XCTAssertTrue(collectionView.waitForExistence(timeout: 1))
		
		var deselectedCells: XCUIElementQuery { return collectionView.cells.matching(identifier: "deselected") }
		var selectedCells: XCUIElementQuery { return collectionView.cells.matching(identifier: "selected") }
		
		// Check initial count of deselected and selected cells
		XCTAssertTrue(deselectedCells.count == 19)
		XCTAssertTrue(selectedCells.count == 0)
		
		// Rotate to landscape
		XCUIDevice.shared.orientation = .landscapeLeft
		

		// Check initial count of deselected and selected cells
		XCTAssertTrue(deselectedCells.count == 49)
		XCTAssertTrue(selectedCells.count == 0)

		// tap 2nd button
		let toggleSecondSetOfFunctions = deselectedCells.allElementsBoundByIndex[10]
		toggleSecondSetOfFunctions.tap()
		
		// Rotate to portrait
		XCUIDevice.shared.orientation = .portrait
		
		// Make sure selected cells == 0
		XCTAssertTrue(deselectedCells.count == 19)
		XCTAssertTrue(selectedCells.count == 0)
		
		// Tap Divide
		let divide = deselectedCells.allElementsBoundByIndex[3]
		divide.tap()
		
		// Make sure de/selected cell count was updated
		XCTAssertTrue(deselectedCells.count == 18)
		XCTAssertTrue(selectedCells.count == 1)
		
		// Rotate back to landscape
		XCUIDevice.shared.orientation = .landscapeLeft
		
		// Make sure selected cell count is 2
		XCTAssertTrue(deselectedCells.count == 47)
		XCTAssertTrue(selectedCells.count == 2)
	}
	
	func testFunctionIsDeselectedInPortraitWhenInput2NonPlusMinusCellIsTapped() {
		let app = XCUIApplication()
		app.launch()
		XCUIDevice.shared.orientation = .landscapeLeft
		
		let collectionView = app.collectionViews.firstMatch
		XCTAssertTrue(collectionView.waitForExistence(timeout: 1))
		
		var deselectedCells: XCUIElementQuery { return collectionView.cells.matching(identifier: "deselected") }
		var selectedCells: XCUIElementQuery { return collectionView.cells.matching(identifier: "selected") }
		
		// Check initial count of deselected and selected cells
		XCTAssertTrue(deselectedCells.count == 49)
		XCTAssertTrue(selectedCells.count == 0)

		// tap 2nd button
		let power = deselectedCells.allElementsBoundByIndex[13]
		XCTAssertTrue(power.label == "power")
		power.tap()
		
		// Rotate to portrait
		XCUIDevice.shared.orientation = .portrait

		// Make sure selected cells == 0
		XCTAssertTrue(deselectedCells.count == 19)
		XCTAssertTrue(selectedCells.count == 0)

		// Tap Divide
		let divide = deselectedCells.allElementsBoundByIndex[3]
		divide.tap()

		// Make sure de/selected cell count was updated
		XCTAssertTrue(deselectedCells.count == 18)
		XCTAssertTrue(selectedCells.count == 1)

		// Rotate back to landscape
		XCUIDevice.shared.orientation = .landscapeLeft

		// Make sure selected cell count is 1
		XCTAssertTrue(deselectedCells.count == 48)
		XCTAssertTrue(selectedCells.count == 1)
		
		// Make sure selected cell is divide
		let selectedCell = selectedCells.firstMatch
		XCTAssertTrue(selectedCell.label == "divide")
	}

}
