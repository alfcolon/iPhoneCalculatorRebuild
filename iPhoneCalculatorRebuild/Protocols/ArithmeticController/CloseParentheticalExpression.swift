//
//  CloseParentheticalExpression.swift
//  iPhoneCalculatorRebuild
//
//  Created by Alfredo Colon on 7/1/20.
//  Copyright © 2020 Alfredo Colon. All rights reserved.
//

import Foundation

protocol CloseParentheticalExpression {
    func addOutputTermIfNeeded()
    func closeParentheticalExpression()
    func closeNestedArithmeticControllerIfNeeded()
}
