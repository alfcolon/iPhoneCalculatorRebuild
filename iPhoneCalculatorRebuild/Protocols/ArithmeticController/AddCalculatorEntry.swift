//
//  AddCalculatorEntry.swift
//  iPhoneCalculatorRebuild
//
//  Created by Alfredo Colon on 7/1/20.
//  Copyright © 2020 Alfredo Colon. All rights reserved.
//

import Foundation

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
