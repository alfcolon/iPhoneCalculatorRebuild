//
//  AddDisplayedNumberAsTermTests.swift
//  iPhoneCalculatorRebuildUnitTests
//
//  Created by Alfredo Colon on 3/14/21.
//  Copyright © 2021 Alfredo Colon. All rights reserved.
//

import XCTest
@testable import iPhoneCalculatorRebuild

class AddDisplayedNumberAsTermTests: XCTestCase {

	func testAddDisplayedNumberAsTermForEqualCellTapped() throws {
		// setup output label and calculator brain
		let outputLabel = OutputLabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
		let calculatorBrain = CalculatorBrain(outputLabelDelegate: outputLabel)
		
		// setup cells to push into the brain to be evaluated
		let addCalculatorCell = CalculatorCell.operator_(.Addition)
		let equalCalculatorCell = CalculatorCell.equal(.Equal)
		let fourCalculatorCell = CalculatorCell.digit(.Four)
		let openParentheses = CalculatorCell.parentheses(.OpeningParenthesis)
		
		// evaluate cells
		calculatorBrain.evaluateSelectedCalculatorCell(fourCalculatorCell)
		calculatorBrain.evaluateSelectedCalculatorCell(addCalculatorCell)
		calculatorBrain.evaluateSelectedCalculatorCell(equalCalculatorCell)
		
		// test output
		var evaluatedDoubleValue: Double = outputLabel.outputTerm.doubleValue ?? 0
		let leftTerm: Double = 4
		var rightTerm: Double = 4
		var expectedValue: Double = leftTerm + rightTerm // 4 + (4 + 4)
		
		XCTAssertTrue(evaluatedDoubleValue == expectedValue)
	}

}
