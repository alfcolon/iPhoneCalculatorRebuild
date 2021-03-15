//
//  SwipeToDeleteTests.swift
//  iPhoneCalculatorRebuildUITests
//
//  Created by Alfredo Colon on 3/14/21.
//  Copyright © 2021 Alfredo Colon. All rights reserved.
//

import XCTest

class SwipeToDeleteTests: XCTestCase {

	func testLeftSwipeRemovesDigit() {
		let app = XCUIApplication()
		app.launch()
		
		let collectionView = app.collectionViews.firstMatch
		let cells = collectionView.cells
		let fourCell = cells["four"]
		XCTAssertTrue(collectionView.exists)
		XCTAssertTrue(fourCell.exists)
		
		fourCell.tap()
		fourCell.tap()
		
		let labelView = app.otherElements["labelView"]
		XCTAssert(labelView.exists)
				
		labelView.swipeLeft()
		
		let outputLabel = labelView.staticTexts.firstMatch
		let outputLabelLabel = outputLabel.label
		
		XCTAssertTrue(outputLabelLabel == "4")
	}
	
	func testLeftSwipeRemovesNegativeSymbol() {
		let app = XCUIApplication()
		app.launch()
		
		let collectionView = app.collectionViews.firstMatch
		let cells = collectionView.cells
		let fourCell = cells["four"]
		let plusMinusCell = cells["plus minus"]
		XCTAssertTrue(collectionView.exists)
		XCTAssertTrue(fourCell.exists)
		XCTAssertTrue(plusMinusCell.exists)
		
		fourCell.tap()
		fourCell.tap()
		plusMinusCell.tap()
		
		let labelView = app.otherElements["labelView"]
		XCTAssert(labelView.exists)
		
		labelView.swipeLeft()
		labelView.swipeLeft()
		
		let outputLabel = labelView.staticTexts["outputLabel"].firstMatch
		outputLabel.swipeLeft()
		
		let outputLabelLabel = outputLabel.label
		XCTAssertTrue(outputLabelLabel == "0")
	}

}
