//
//  MutableOperand.swift
//  iPhoneCalculatorRebuild
//
//  Created by Alfredo Colon on 6/16/20.
//  Copyright © 2020 Alfredo Colon. All rights reserved.
//

import Foundation

class MutableOperand: SignCanToggle, DoubleValue {
    
    //MARK: - Properites
    
    var decimal: Bool
    var fractionArray: [String]
    var integerArray: [String]
    
    //MARK: - Init
    
    init(decimal: CalculatorCell.Decimal?, startingDigit: CalculatorCell.Digit, toggleSign: Bool) {
        self.decimal = decimal == nil ? false : true
        
        self.fractionArray = []
        
        self.integerArray = []
        self.integerArray.append(startingDigit.rawValue)
        
        super.init()
        
        self.toggleSign = toggleSign
    }
    
    //MARK: - Methods
    
    func addDecimal() {
        guard self.decimal == false else { return }
        
        self.decimal.toggle()
    }
    
    func addDigit(digit: CalculatorCell.Digit) {
        //1. First check that the mutable operand hasn't reached it's character limit
        let digitCount: Int = self.fractionArray.count + self.integerArray.count
        
        switch Calculators.active {
        case .scientific:
			guard digitCount < Calculators.scientific.numberFormatter.decimalDigitMaximum else { return }
        case .standard:
			guard digitCount < Calculators.standard.numberFormatter.decimalDigitMaximum else { return }
        }
        
        //2. Then check if the digit needs to be added to as a fraction
        guard !self.decimal else { return self.fractionArray.append(digit.rawValue) }
        
        //3. Then add digit as long as it isn't a double zero situation
        if integerArray == ["0"] {
            integerArray[0] = digit.rawValue
        }
        else {
            self.integerArray.append(digit.rawValue)
        }
    }
    
    func doubleValue() -> Double? {
        let doubleArray: [String] = decimal ? integerArray + ["."] + fractionArray : integerArray
        let double: Double! = Double(doubleArray.joined())
        
        return self.toggleSign ? -double : double
    }
    
    func removeLastDigit() {
        switch true {
        case self.fractionArray.count > 0:
            self.fractionArray.removeLast()
        case self.decimal == true:
            self.decimal = false
        case self.integerArray.count > 1:
            self.integerArray.removeLast()
        default:
            self.integerArray[0] = "0"
        }
    }
    
//    func toggleSignForSwipe(swipeLocation: CGPoint)
}
