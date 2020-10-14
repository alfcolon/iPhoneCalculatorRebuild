//
//  CalculatorBrain.swift
//  iPhoneCalculatorRebuild
//
//  Created by Alfredo Colon on 6/12/20.
//  Copyright © 2020 Alfredo Colon. All rights reserved.
//

import Foundation

struct StartingValues: Codable {
    // Set these values as optional in case they are set to an "Error" (nil) value
    var startingTermDouble: Double?
    var memoryRecallDouble: Double?
    
    init() {
        self.memoryRecallDouble = 0
        self.startingTermDouble = 0
    }
}

class CalculatorBrain: PersistStartingValues {

    //  MARK: - Properties

    var arithmeticController: ArithmeticController
    var memoryRecall: MemoryRecall
    var siUnit: CalculatorCell.SIUnit
    var startingValues: StartingValues?

    //  MARK: - Init

    init(outputLabelDelegate: OutputLabel) {
        let startingTerm: Term = Term(startingDigit: CalculatorCell.Digit.Zero)
        self.arithmeticController = ArithmeticController(outputLabelDelegate: outputLabelDelegate, startingTerm: startingTerm)
        
        self.memoryRecall = MemoryRecall()
        
        self.siUnit = .Radians
        
        self.loadFromPersistentStore()
         
        if self.startingValues == nil {
            self.startingValues = StartingValues()
        }
        else {
            self.memoryRecall.double = self.startingValues?.memoryRecallDouble
            self.arithmeticController.addCalculatorEntry(double: self.startingValues?.startingTermDouble)
        }
    }

    //MARK: - Evaluate Calculator Cell
    
    func evaluateSelectedCalculatorCell(_ calculatorCell: CalculatorCell) {
        switch calculatorCell {
        case .clear(let clear):
            switch clear {
            case .AllClear:
                self.arithmeticController.clearAllEntries()
            case .ClearEntry:
                self.arithmeticController.clearLastTerm()
            }
        case .constant(let constantType):
            switch constantType {
            case .RandomNumber:
                self.arithmeticController.addCalculatorEntry(double: Double.random(in: 0..<1))
            default:
                self.arithmeticController.addCalculatorEntry(constantType: constantType)
            }
        case .decimal(let decimal):
            self.arithmeticController.addCalculatorEntry(decimal: decimal)
        case .digit(let digit):
            self.arithmeticController.addCalculatorEntry(digit: digit)
        case .equal:
            self.arithmeticController.evaluateArithmeticExpression()
        case .exponentFunction(let function):
            switch function {
            case .BaseEulersNumberPowerX,
                 .BaseTenPowerX,
                 .BaseTwoPowerX,
                 .BaseXPowerThree,
                 .BaseXPowerTwo:
                self.arithmeticController.addCalculatorEntry(functionWithOneInput: calculatorCell)
            case .BaseXPowerY,
                 .BaseYPowerX,
                 .EnterExponent:
                self.arithmeticController.addCalculatorEntry(functionWithTwoInputs: calculatorCell)
            }
        case .factorial:
            self.arithmeticController.addCalculatorEntry(functionWithOneInput: calculatorCell)
        case .logFunction(let function):
            switch function {
            case .LogBaseTen,
                 .LogBaseTwo,
                 .NaturalLog:
                self.arithmeticController.addCalculatorEntry(functionWithOneInput: calculatorCell)
            case .LogBaseY:
                self.arithmeticController.addCalculatorEntry(functionWithTwoInputs: calculatorCell)
            }
        case .memoryRecall(let memoryRecallCell):
            switch memoryRecallCell {
            case .MemoryClear:
                self.memoryRecall.clear()
            case .MemoryMinus:
                let double = self.arithmeticController.outputLabelDelegate.outputTerm.doubleValue
                self.memoryRecall.addToMemoryRecall(double: double)
            case .MemoryPlus:
                let double = self.arithmeticController.outputLabelDelegate.outputTerm.doubleValue
                self.memoryRecall.addToMemoryRecall(double: double)
            case .MemoryRecall:
                let double: Double? = self.memoryRecall.doubleValue()
                self.arithmeticController.addCalculatorEntry(double: double)
            }
        case .operator_(let operatorType):
            self.arithmeticController.addCalculatorEntry(operatorType: operatorType)
        case .parentheses(let parenthesis):
            switch parenthesis {
            case .ClosingParenthesis:
                self.arithmeticController.closeParentheticalExpression()
            case .OpeningParenthesis:
                self.arithmeticController.addParentheticalExpression()
            }
        case .percentageFunction(let function):
            self.arithmeticController.addCalculatorEntry(percentageFunction: function)
        case .reciprocal:
            self.arithmeticController.addCalculatorEntry(functionWithOneInput: calculatorCell)
        case .rootFunction(let function):
            switch function {
            case .CoefficientThreeRadicandX,
                 .CoefficientTwoRadicandX:
                self.arithmeticController.addCalculatorEntry(functionWithOneInput: calculatorCell)
            case .CoefficientYRadicandX:
                self.arithmeticController.addCalculatorEntry(functionWithTwoInputs: calculatorCell)
            }
        case .siUnit(let unit):
            self.siUnit = unit
        case .trigonometricHyperbolicFunction,
             .trigonometricInverseHyperbolicFunction,
             .trigonometricInverseRightAngleFunction,
             .trigonometricRightAngleFunction:
            self.arithmeticController.addCalculatorEntry(trigonometricFunction: calculatorCell, siUnit: self.siUnit)
        case .toggleNumberSign:
            self.arithmeticController.toggleNumberSign()
        case .toggleSecondSetOfFunctions:
            self.arithmeticController.removeToggledFunctionIfNeeded()
        }
        
        self.saveToPersistentStore()
    }
    
    //MARK: - PersistStartingValues
    
    var persistentFileURL: URL? {
        //1.Access the file manager
        let fileManager: FileManager = FileManager.default
        
        //2.Get the first url in the Apps document folder
        guard let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        //3.Return url
        return documents.appendingPathComponent("StartingValues.plist")
    }
    
    func loadFromPersistentStore(){
        let fileManager = FileManager.default
        guard let url = persistentFileURL,
            fileManager.fileExists(atPath: url.path) else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            self.startingValues = try decoder.decode(StartingValues.self, from: data)
        } catch {
            print("Error saving startingValues data: \(error)")
        }
    }
    
    func saveToPersistentStore() {
        guard let url = persistentFileURL else { return }
        
        self.startingValues?.memoryRecallDouble = self.memoryRecall.doubleValue()
        self.startingValues?.startingTermDouble = self.arithmeticController.outputLabelDelegate.outputTerm.doubleValue
        
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(self.startingValues)
            
            try data.write(to: url)
        } catch {
            print("Error saving startingValues data: \(error)")
        }
    }
}
