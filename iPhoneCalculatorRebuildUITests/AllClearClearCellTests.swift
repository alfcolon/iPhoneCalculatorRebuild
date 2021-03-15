//
//  AllClearClearCellTests.swift
//  iPhoneCalculatorRebuildUITests
//
//  Created by Alfredo Colon on 3/14/21.
//  Copyright © 2021 Alfredo Colon. All rights reserved.
//

import XCTest

class AllClearClearCellTests: XCTestCase {

	func testDigitSwitchesAllClearToClear() {
		let app = XCUIApplication()
		app.launch()
		
		let collectionView = app.collectionViews.firstMatch
		let cells = collectionView.cells
		XCTAssertTrue(collectionView.exists)
		
		let allClear = cells["all clear"].firstMatch
		XCTAssertTrue(allClear.exists)
		
		let digit = cells["seven"].firstMatch
		digit.tap()
		
		let clear = cells["clear"].firstMatch
		XCTAssert(clear.exists)
	}
	
	func testConstantSwitchesAllClearToClear() {
		let app = XCUIApplication()
		app.launch()
		
		let device = XCUIDevice.shared
		device.orientation = .landscapeLeft
		
		let collectionView = app.collectionViews.firstMatch
		let cells = collectionView.cells
		XCTAssertTrue(collectionView.exists)
		
		let allClear = cells["all clear"].firstMatch
		XCTAssertTrue(allClear.exists)
		
		let constant = cells["pi"]
		XCTAssertTrue(constant.exists)
		constant.tap()
		
		let clear = cells["clear"].firstMatch
		XCTAssert(clear.exists)
	}
	
	func testDecimalSwitchesAllClearToClear() {
		let app = XCUIApplication()
		app.launch()
		
		let collectionView = app.collectionViews.firstMatch
		let cells = collectionView.cells
		XCTAssertTrue(collectionView.exists)
		
		let allClear = cells["all clear"].firstMatch
		XCTAssertTrue(allClear.exists)
		
		let decimal = cells["decimal"]
		XCTAssertTrue(decimal.exists)
		decimal.tap()
		
		let clear = cells["clear"].firstMatch
		XCTAssert(clear.exists)
	}
	
	func testClearSwitchesClearToAllClear() {
		let app = XCUIApplication()
		app.launch()
		
		let collectionView = app.collectionViews.firstMatch
		let cells = collectionView.cells
		XCTAssertTrue(collectionView.exists)
		
		var allClear = cells["all clear"].firstMatch
		XCTAssertTrue(allClear.exists)
		
		let decimal = cells["decimal"]
		XCTAssertTrue(decimal.exists)
		decimal.tap()
		
		let clear = cells["clear"].firstMatch
		XCTAssert(clear.exists)
		
		clear.tap()
		allClear = cells["all clear"].firstMatch
		XCTAssertTrue(allClear.exists)
	}

}
