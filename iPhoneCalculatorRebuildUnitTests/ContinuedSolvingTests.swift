//
//  ContinuedSolvingTests.swift
//  iPhoneCalculatorRebuildUnitTests
//
//  Created by Alfredo Colon on 3/14/21.
//  Copyright © 2021 Alfredo Colon. All rights reserved.
//

import XCTest
@testable import iPhoneCalculatorRebuild

class ContinuedSolvingTests: XCTestCase {

	func testContinuedFunctionWithOneInput() throws {
		// setup output label and calculator brain
		let outputLabel = OutputLabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
		let calculatorBrain = CalculatorBrain(outputLabelDelegate: outputLabel)
		
		// setup cells to push into the brain to be evaluated
		let fourCalculatorCell = CalculatorCell.digit(CalculatorCell.Digit.Four)
		let squaredCalculatorCell = CalculatorCell.exponentFunction(CalculatorCell.ExponentFunction.BaseXPowerTwo)
		let equalCalculatorCell = CalculatorCell.equal(CalculatorCell.Equal.Equal)
		
		// evaluate cells
		calculatorBrain.evaluateSelectedCalculatorCell(fourCalculatorCell)
		calculatorBrain.evaluateSelectedCalculatorCell(squaredCalculatorCell)
		calculatorBrain.evaluateSelectedCalculatorCell(equalCalculatorCell)
		
		// test output
		var evaluatedDoubleValue: Double = outputLabel.outputTerm.doubleValue ?? 0
		var expectedValue: Double = 16 // 4 ^ 2
		XCTAssertTrue(evaluatedDoubleValue == expectedValue)
		
		// continue operation
		calculatorBrain.evaluateSelectedCalculatorCell(equalCalculatorCell)
		
		// test output
		evaluatedDoubleValue = outputLabel.outputTerm.doubleValue ?? 0
		expectedValue *= expectedValue
		XCTAssertTrue(evaluatedDoubleValue == expectedValue)
	}
	
	func testContinuedFunctionWithTwoInputs() throws {
		// setup output label and calculator brain
		let outputLabel = OutputLabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
		let calculatorBrain = CalculatorBrain(outputLabelDelegate: outputLabel)
		
		// setup cells to push into the brain to be evaluated
		let fourCalculatorCell = CalculatorCell.digit(CalculatorCell.Digit.Four)
		let baseXPowerYCalculatorCell = CalculatorCell.exponentFunction(CalculatorCell.ExponentFunction.BaseXPowerY)
		let equalCalculatorCell = CalculatorCell.equal(CalculatorCell.Equal.Equal)
		
		// evaluate cells
		calculatorBrain.evaluateSelectedCalculatorCell(fourCalculatorCell)
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
	
	func testContinuedOperationWithTheRightTermAsParentheticalExpressionTotal() throws {
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
		calculatorBrain.evaluateSelectedCalculatorCell(openParentheses)
		calculatorBrain.evaluateSelectedCalculatorCell(fourCalculatorCell)
		calculatorBrain.evaluateSelectedCalculatorCell(addCalculatorCell)
		calculatorBrain.evaluateSelectedCalculatorCell(fourCalculatorCell)
		calculatorBrain.evaluateSelectedCalculatorCell(equalCalculatorCell)
		
		// test output
		var evaluatedDoubleValue: Double = outputLabel.outputTerm.doubleValue ?? 0
		let leftTerm: Double = 4
		let rightTerm: Double = 4 + 4
		var expectedValue: Double = leftTerm + rightTerm // 4 + (4 + 4)
		XCTAssertTrue(evaluatedDoubleValue == expectedValue)
		
		// continue operation
		calculatorBrain.evaluateSelectedCalculatorCell(equalCalculatorCell)
		
		// test output
		evaluatedDoubleValue = outputLabel.outputTerm.doubleValue ?? 0
		expectedValue += rightTerm
		XCTAssertTrue(evaluatedDoubleValue == expectedValue)
	}

}
