//
//  EvaluateNewOperator.swift
//  iPhoneCalculatorRebuild
//
//  Created by Alfredo Colon on 7/1/20.
//  Copyright © 2020 Alfredo Colon. All rights reserved.
//

import Foundation

protocol EvaluateNewOperator {
    func demotePrecedence(for newOperator: CalculatorCell.Operator)
    func promotePrecedence(for newOperator: CalculatorCell.Operator)
    func updatePrecedenceOperations(for newOperator: CalculatorCell.Operator)
}
