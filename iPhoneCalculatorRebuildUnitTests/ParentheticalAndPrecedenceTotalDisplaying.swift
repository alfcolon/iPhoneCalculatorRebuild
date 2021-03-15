//
//  ParentheticalAndPrecedenceTotalDisplaying.swift
//  iPhoneCalculatorRebuildUnitTests
//
//  Created by Alfredo Colon on 3/14/21.
//  Copyright © 2021 Alfredo Colon. All rights reserved.
//

import XCTest
@testable import iPhoneCalculatorRebuild

class ParentheticalAndPrecedenceTotalDisplaying: XCTestCase {

	func testPrecedenceExpressionTotalDisplaying() throws {
		// setup output label and calculator brain
		let outputLabel = OutputLabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
		let calculatorBrain = CalculatorBrain(outputLabelDelegate: outputLabel)
		
		// setup cells to push into the brain to be evaluated
		let twoCalculatorCell = CalculatorCell.digit(.Two)
		let fourCalculatorCell = CalculatorCell.digit(.Four)
		let addCalculatorCell = CalculatorCell.operator_(.Addition)
		let multiplyCalculatorCell = CalculatorCell.operator_(.Multiplication)
		
		// evaluate cells
		calculatorBrain.evaluateSelectedCalculatorCell(twoCalculatorCell)
		calculatorBrain.evaluateSelectedCalculatorCell(addCalculatorCell)
		calculatorBrain.evaluateSelectedCalculatorCell(fourCalculatorCell)
		calculatorBrain.evaluateSelectedCalculatorCell(multiplyCalculatorCell)
		
		// test output
		let evaluatedDoubleValue: Double = outputLabel.outputTerm.doubleValue ?? 0
		let expectedValue: Double = 4 // multiplication has a higher precedence than addition, so 4 will be the first left operand in the new precedence and its total
		XCTAssertTrue(evaluatedDoubleValue == expectedValue)
	}
	
	func testParentheticalExpressionTotalDisplaying() throws {
		// setup output label and calculator brain
		let outputLabel = OutputLabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
		let calculatorBrain = CalculatorBrain(outputLabelDelegate: outputLabel)
		
		// setup cells to push into the brain to be evaluated
		let twoCalculatorCell = CalculatorCell.digit(.Two)
		let fourCalculatorCell = CalculatorCell.digit(.Four)
		let addCalculatorCell = CalculatorCell.operator_(.Addition)
		let multiplyCalculatorCell = CalculatorCell.operator_(.Multiplication)
		
		// evaluate cells
		calculatorBrain.evaluateSelectedCalculatorCell(twoCalculatorCell)
		calculatorBrain.evaluateSelectedCalculatorCell(addCalculatorCell)
		calculatorBrain.evaluateSelectedCalculatorCell(fourCalculatorCell)
		calculatorBrain.evaluateSelectedCalculatorCell(addCalculatorCell)
		
		// test output
		let evaluatedDoubleValue: Double = outputLabel.outputTerm.doubleValue ?? 0
		let expectedValue: Double = 2 + 4 // a higher precedence operator hasn't been used so the parenthetical total here is 2 + 4 as their evaluated total acts as the left expression
		XCTAssertTrue(evaluatedDoubleValue == expectedValue)
	}

}
