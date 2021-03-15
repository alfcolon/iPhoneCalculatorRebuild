//
//  LayoutTests.swift
//  iPhoneCalculatorRebuildUITests
//
//  Created by Alfredo Colon on 3/14/21.
//  Copyright © 2021 Alfredo Colon. All rights reserved.
//

import XCTest

class LayoutTests: XCTestCase {

	func testLayoutPortrait() {
		let app = XCUIApplication()
		app.launch()

		let device = XCUIDevice.shared
		device.orientation = .portrait
		
		let collectionView = app.collectionViews["collectionView"]
		let mainView = app.otherElements["mainView"]
		let labelView = app.otherElements["labelView"]

		XCTAssertTrue(collectionView.exists)
		XCTAssertTrue(mainView.exists)
		XCTAssertTrue(labelView.exists)

		let mainViewFrameHeight = mainView.frame.height
		
		let collectionViewFrameHeight = collectionView.frame.height
		let labelViewFrameHeight = labelView.frame.height
		let combinedHeight = collectionViewFrameHeight + labelViewFrameHeight
		
		XCTAssert(mainViewFrameHeight > combinedHeight)
	}
	
	func testLayoutLandscape() {
		let app = XCUIApplication()
		app.launch()

		let device = XCUIDevice.shared
		device.orientation = .landscapeLeft

		let collectionView = app.collectionViews["collectionView"]
		let mainView = app.otherElements["mainView"]
		let labelView = app.otherElements["labelView"]

		XCTAssertTrue(collectionView.exists)
		XCTAssertTrue(mainView.exists)
		XCTAssertTrue(labelView.exists)

		let mainViewFrameHeight = mainView.frame.height
		
		let collectionViewFrameHeight = collectionView.frame.height
		let labelViewFrameHeight = labelView.frame.height
		let combinedHeight = collectionViewFrameHeight + labelViewFrameHeight
		
		XCTAssert(mainViewFrameHeight > combinedHeight)
	}

}
