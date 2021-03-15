//
//  CopyAndPasteTests.swift
//  iPhoneCalculatorRebuildUITests
//
//  Created by Alfredo Colon on 3/14/21.
//  Copyright © 2021 Alfredo Colon. All rights reserved.
//

import XCTest

class CopyAndPasteTests: XCTestCase {

	func testCopyPaste() {
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
		
		let outputLabel = labelView.staticTexts["outputLabel"].firstMatch
		outputLabel.press(forDuration: 1)
		
		var menu = app.menus.firstMatch
		
		let menuItemCopy = menu.menuItems["Copy"].firstMatch
		XCTAssertTrue(menuItemCopy.exists)
		menuItemCopy.tap()
		
		fourCell.tap()
		fourCell.tap()
		
		outputLabel.press(forDuration: 1)
		menu = app.menus.firstMatch
		
		let menuItemPaste = menu.menuItems["Paste"].firstMatch
		XCTAssertTrue(menuItemPaste.exists)
		menuItemPaste.tap()
		let lv = app.otherElements["labelView"]
		XCTAssert(lv.exists)
		
		let outputLabelText = app.otherElements["labelView"].firstMatch.staticTexts["outputLabel"].label
		XCTAssertTrue(outputLabelText == "−44")
	}

}
