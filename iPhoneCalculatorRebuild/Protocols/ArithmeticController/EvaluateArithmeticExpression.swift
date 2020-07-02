//
//  EvaluateArithmeticExpression.swift
//  iPhoneCalculatorRebuild
//
//  Created by Alfredo Colon on 7/1/20.
//  Copyright © 2020 Alfredo Colon. All rights reserved.
//

import Foundation

protocol EvaluateArithmeticExpression {
    func addOutputTermIfNeeded()
    func evaluateArithmeticExpression()
    func updateFinalTerm(finalTermPointer: UnsafeMutablePointer<Term>)
}
