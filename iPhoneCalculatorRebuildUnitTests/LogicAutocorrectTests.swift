//
//  LogicAutocorrectTests.swift
//  iPhoneCalculatorRebuildUnitTests
//
//  Created by Alfredo Colon on 3/14/21.
//  Copyright © 2021 Alfredo Colon. All rights reserved.
//

import XCTest
@testable import iPhoneCalculatorRebuild

class LogicAutocorrectTests: XCTestCase {

	func testAutoCorrectFunctionWithTwoInputsAddedAfterAnOperator() throws {
		// setup output label and calculator brain
		let outputLabel = OutputLabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
		let calculatorBrain = CalculatorBrain(outputLabelDelegate: outputLabel)
		
		// setup cells to push into the brain to be evaluated
		let fourCalculatorCell = CalculatorCell.digit(.Four)
		let addCalculatorCell = CalculatorCell.operator_(.Addition)
		let baseXPowerYCalculatorCell = CalculatorCell.exponentFunction(.BaseXPowerY)
		let equalCalculatorCell = CalculatorCell.equal(.Equal)
		
		// evaluate cells
		calculatorBrain.evaluateSelectedCalculatorCell(fourCalculatorCell)
		calculatorBrain.evaluateSelectedCalculatorCell(addCalculatorCell)
		calculatorBrain.evaluateSelectedCalculatorCell(baseXPowerYCalculatorCell)
		calculatorBrain.evaluateSelectedCalculatorCell(fourCalculatorCell)
		calculatorBrain.evaluateSelectedCalculatorCell(equalCalculatorCell)
		
		// test output
		var evaluatedDoubleValue: Double = outputLabel.outputTerm.doubleValue ?? 0
		var expectedValue: Double = pow(4, 4) // 4 ^ 4
		XCTAssertTrue(evaluatedDoubleValue == expectedValue)
		
		// continue operation
		calculatorBrain.evaluateSelectedCalculatorCell(equalCalculatorCell)
		
		// test output
		evaluatedDoubleValue = outputLabel.outputTerm.doubleValue ?? 0
		expectedValue = pow(expectedValue, 4) // (4 ^ 4) ^ 4
		XCTAssertTrue(evaluatedDoubleValue == expectedValue)
	}
	
	func testAutoCorrectFunctionWithTwoInputsAddedToAnEmptyParentheticalExpression() throws {
		// setup output label and calculator brain
		let outputLabel = OutputLabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
		let calculatorBrain = CalculatorBrain(outputLabelDelegate: outputLabel)
		
		// setup cells to push into the brain to be evaluated
		let twoCalculatorCell = CalculatorCell.digit(.Two)
		let fourCalculatorCell = CalculatorCell.digit(.Four)
		let addCalculatorCell = CalculatorCell.operator_(.Addition)
		let baseXPowerYCalculatorCell = CalculatorCell.exponentFunction(.BaseXPowerY)
		let openParentheses = CalculatorCell.parentheses(.OpeningParenthesis)
		let equalCalculatorCell = CalculatorCell.equal(.Equal)
		
		// evaluate cells
		calculatorBrain.evaluateSelectedCalculatorCell(twoCalculatorCell)
		calculatorBrain.evaluateSelectedCalculatorCell(addCalculatorCell)
		calculatorBrain.evaluateSelectedCalculatorCell(openParentheses)
		calculatorBrain.evaluateSelectedCalculatorCell(baseXPowerYCalculatorCell)
		calculatorBrain.evaluateSelectedCalculatorCell(fourCalculatorCell)
		calculatorBrain.evaluateSelectedCalculatorCell(equalCalculatorCell)
		
		// test output
		let evaluatedDoubleValue: Double = outputLabel.outputTerm.doubleValue ?? 0
		let expectedValue: Double = pow(2, 4) // 4 ^ 4
		XCTAssertTrue(evaluatedDoubleValue == expectedValue)
	}

}
