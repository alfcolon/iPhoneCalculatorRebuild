//
//  AddCalculatorEntry.swift
//  iPhoneCalculatorRebuild
//
//  Created by Alfredo Colon on 7/1/20.
//  Copyright © 2020 Alfredo Colon. All rights reserved.
//

import Foundation


//update a term with this
//func addCalculatorEntry(from constantType: CalculatorCell.Constant)
//func addCalculatorEntry(from decimal: CalculatorCell.Decimal)
//func addCalculatorEntry(from double: Double?)
//func addCalculatorEntry(from digit: CalculatorCell.Digit)


//update term or outputTerm
//func addCalculatorEntry(functionWithOneInput: CalculatorCell)
//func addCalculatorEntry(trigonometricFunction: CalculatorCell, siUnit: CalculatorCell.SIUnit)

// percentage function
//func addCalculatorEntry(percentageFunction: CalculatorCell.PercentageFunction)


//Two terms
//func addCalculatorEntry(functionWithTwoInputs: CalculatorCel
//func addCalculatorEntry(operatorType: CalculatorCell.Operator)


//add number

//add functionWithOneInput

//add


/*
 clearAllTerm
 clearlastTerm
 
 updatePrecedenceTerm
 updatePrecedenceOrOutputTerm
 updateParentheticalExpressions
 */

protocol AddCalculatorEntry {
    func addCalculatorEntry(constantType: CalculatorCell.Constant)
    func addCalculatorEntry(decimal: CalculatorCell.Decimal)
    func addCalculatorEntry(double: Double?)
    func addCalculatorEntry(functionWithOneInput: CalculatorCell)
    func addCalculatorEntry(functionWithTwoInputs: CalculatorCell)
    func addCalculatorEntry(digit: CalculatorCell.Digit)
    func addCalculatorEntry(operatorType: CalculatorCell.Operator)
    func addCalculatorEntry(percentageFunction: CalculatorCell.PercentageFunction)
    func addCalculatorEntry(trigonometricFunction: CalculatorCell, siUnit: CalculatorCell.SIUnit)
    func addLastTermToEmptyParentheticalStackOrRemoveLastOperatorIfNeeded(functionWithTwoInputs: Bool)
    func moveLastPrecedenceOperationToCurrentPrecedenceOperation()
    var lastPrecedenceTermPointer: UnsafeMutablePointer<Term> { get }
    var lastPrecedenceOrOutputTermPointer: UnsafeMutablePointer<Term> { get }
    var precedenceOperationsHaveStarted: Bool { get }
}

protocol AddParentheticalExpression {
    func addParentheticalExpression()
}

protocol ClearAllEntries {
    func clearAllEntries(startingTerm: Term)
    var lastPrecedenceOrOutputTermPointer: UnsafeMutablePointer<Term> { get }
}

protocol ClearLastTerm {
    func clearLastTerm()
}

protocol CloseParentheticalExpression {
    func addOutputTermIfNeeded()
    func closeParentheticalExpression()
    func closeNestedArithmeticControllerIfNeeded()
}

protocol EvaluateArithmeticExpression {
    func addOutputTermIfNeeded()
    func evaluateArithmeticExpression()
    func updateFinalTerm(finalTermPointer: UnsafeMutablePointer<Term>)
}

protocol SecondSetOfFunctionsToggled {
    func removeToggledFunctionIfNeeded()
}

protocol ToggleNumberSign {
    func toggleNumberSign()
}
    
//func addCalculatorEntry(functionWithTwoInputs: CalculatorCell) {
//    self.addLastTermToEmptyParentheticalStackOrRemoveLastOperatorIfNeeded(functionWithTwoInputs: true)
//    let termPointer: UnsafeMutablePointer<Term>! = self.lastPrecedenceTermPointer
//    let input1 = termPointer.pointee
//    
//    switch termPointer.pointee {
//    case .nestedArithmeticController(let arithmeticController):
//        return arithmeticController.addCalculatorEntry(functionWithTwoInputs: functionWithTwoInputs)
//    default:
//        termPointer.pointee.updateTerm(functionWithTwoInputs: functionWithTwoInputs, input1: input1)
//    }
//    
//    self.outputLabelDelegate.outputTerm.updateTerm(to: input1)
//}
//
//func addCalculatorEntry(operatorType: CalculatorCell.Operator) {
//    self.addLastTermToEmptyParentheticalStackOrRemoveLastOperatorIfNeeded(functionWithTwoInputs: true)
//    let termPointer: UnsafeMutablePointer<Term>! = self.lastPrecedenceTermPointer
//    
//    switch termPointer?.pointee {
//    case .nestedArithmeticController(let arithmeticController):
//        return arithmeticController.addCalculatorEntry(operatorType: operatorType)
//    default:
//        self.precedenceOperations[self.parentheticalExpressionIndex]?.updatePrecedenceOperations(for: operatorType)
//    }
//    
//    let currentPrecedenceOperation = self.precedenceOperations[self.parentheticalExpressionIndex]?.currentPrecedenceOperation
//    let double = currentPrecedenceOperation?.leftTerm.doubleValue
//
//    self.outputLabelDelegate.outputTerm.updateTerm(to: double)
//}
