//
//  MemoryRecallTests.swift
//  iPhoneCalculatorRebuildUnitTests
//
//  Created by Alfredo Colon on 3/15/21.
//  Copyright © 2021 Alfredo Colon. All rights reserved.
//

import XCTest
@testable import iPhoneCalculatorRebuild

class MemoryRecallTests: XCTestCase {

	func testMemoryRecallClear() throws {
		// setup output label and calculator brain
		let outputLabel = OutputLabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
		let calculatorBrain = CalculatorBrain(outputLabelDelegate: outputLabel)
		
		// setup cells to push into the brain to be evaluated
		let memoryRecall = CalculatorCell.memoryRecall(.MemoryRecall)
		let memoryRecallClear = CalculatorCell.memoryRecall(.MemoryClear)
		let memoryRecallPlus = CalculatorCell.memoryRecall(.MemoryPlus)
		let memoryRecallMinus = CalculatorCell.memoryRecall(.MemoryMinus)
		
		calculatorBrain.evaluateSelectedCalculatorCell(memoryRecallClear)
		
		XCTAssertTrue(calculatorBrain.memoryRecall.doubleValue() != nil)
		XCTAssertTrue(calculatorBrain.memoryRecall.doubleValue()! == 0)
	}
	
	func testMemoryRecallPlus() throws {
		// setup output label and calculator brain
		let outputLabel = OutputLabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
		let calculatorBrain = CalculatorBrain(outputLabelDelegate: outputLabel)
		
		// setup cells to push into the brain to be evaluated
		let memoryRecall = CalculatorCell.memoryRecall(.MemoryRecall)
		let memoryRecallClear = CalculatorCell.memoryRecall(.MemoryClear)
		let memoryRecallPlus = CalculatorCell.memoryRecall(.MemoryPlus)
		let memoryRecallMinus = CalculatorCell.memoryRecall(.MemoryMinus)
		
		calculatorBrain.evaluateSelectedCalculatorCell(memoryRecallClear)
		
		XCTAssertTrue(calculatorBrain.memoryRecall.doubleValue() != nil)
		XCTAssertTrue(calculatorBrain.memoryRecall.doubleValue()! == 0)
		
		calculatorBrain.evaluateSelectedCalculatorCell(CalculatorCell.digit(.Four))
		calculatorBrain.evaluateSelectedCalculatorCell(CalculatorCell.digit(.Four))
		calculatorBrain.evaluateSelectedCalculatorCell(memoryRecallPlus)
		
		XCTAssertTrue(calculatorBrain.memoryRecall.doubleValue() != nil)
		XCTAssertTrue(calculatorBrain.memoryRecall.doubleValue()! == 44)
	}
	
	func testMemoryRecallMinus() throws {
		// setup output label and calculator brain
		let outputLabel = OutputLabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
		let calculatorBrain = CalculatorBrain(outputLabelDelegate: outputLabel)
		
		// setup cells to push into the brain to be evaluated
		let memoryRecall = CalculatorCell.memoryRecall(.MemoryRecall)
		let memoryRecallClear = CalculatorCell.memoryRecall(.MemoryClear)
		let memoryRecallPlus = CalculatorCell.memoryRecall(.MemoryPlus)
		let memoryRecallMinus = CalculatorCell.memoryRecall(.MemoryMinus)
		
		calculatorBrain.evaluateSelectedCalculatorCell(memoryRecallClear)
		
		XCTAssertTrue(calculatorBrain.memoryRecall.doubleValue() != nil)
		XCTAssertTrue(calculatorBrain.memoryRecall.doubleValue()! == 0)
		
		calculatorBrain.evaluateSelectedCalculatorCell(CalculatorCell.digit(.Four))
		calculatorBrain.evaluateSelectedCalculatorCell(CalculatorCell.digit(.Four))
		calculatorBrain.evaluateSelectedCalculatorCell(memoryRecallPlus)
		
		XCTAssertTrue(calculatorBrain.memoryRecall.doubleValue() != nil)
		XCTAssertTrue(calculatorBrain.memoryRecall.doubleValue()! == 44)
		
		calculatorBrain.evaluateSelectedCalculatorCell(CalculatorCell.clear(.AllClear))
		calculatorBrain.evaluateSelectedCalculatorCell(CalculatorCell.digit(.Four))
		calculatorBrain.evaluateSelectedCalculatorCell(memoryRecallMinus)
		
		XCTAssertTrue(calculatorBrain.memoryRecall.doubleValue() != nil)
		XCTAssertTrue(calculatorBrain.memoryRecall.doubleValue()! == 40)
	}
	
	func testMemoryRecall() throws {
		// setup output label and calculator brain
		let outputLabel = OutputLabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
		let calculatorBrain = CalculatorBrain(outputLabelDelegate: outputLabel)
		
		// setup cells to push into the brain to be evaluated
		let memoryRecall = CalculatorCell.memoryRecall(.MemoryRecall)
		let memoryRecallClear = CalculatorCell.memoryRecall(.MemoryClear)
		let memoryRecallPlus = CalculatorCell.memoryRecall(.MemoryPlus)
		let memoryRecallMinus = CalculatorCell.memoryRecall(.MemoryMinus)
		
		calculatorBrain.evaluateSelectedCalculatorCell(memoryRecallClear)
		
		XCTAssertTrue(calculatorBrain.memoryRecall.doubleValue() != nil)
		XCTAssertTrue(calculatorBrain.memoryRecall.doubleValue()! == 0)
		
		calculatorBrain.evaluateSelectedCalculatorCell(CalculatorCell.digit(.Four))
		calculatorBrain.evaluateSelectedCalculatorCell(CalculatorCell.digit(.Four))
		calculatorBrain.evaluateSelectedCalculatorCell(memoryRecallPlus)
		
		XCTAssertTrue(calculatorBrain.memoryRecall.doubleValue() != nil)
		XCTAssertTrue(calculatorBrain.memoryRecall.doubleValue()! == 44)
		
		calculatorBrain.evaluateSelectedCalculatorCell(memoryRecall)
		
		XCTAssertTrue(outputLabel.outputTerm.doubleValue != nil)
		XCTAssertTrue(outputLabel.outputTerm.doubleValue! == 44)
	}

}
