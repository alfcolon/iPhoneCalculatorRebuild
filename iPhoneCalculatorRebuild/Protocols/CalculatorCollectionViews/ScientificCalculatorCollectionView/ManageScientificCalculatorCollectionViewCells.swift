//
//  ManageScientificCalculatorCollectionViewCells.swift
//  iPhoneCalculatorRebuild
//
//  Created by Alfredo Colon on 6/30/20.
//  Copyright © 2020 Alfredo Colon. All rights reserved.
//

import Foundation

protocol ManageScientificCalculatorCollectionViewCells  {
    func deselectAllCellsThatAppearToBeSelectedIfNeeded()
    func deselectOperatorIfNeeded(selectedCellIndex: Int)
    func deselectFunctionWithTwoInputsIfNeeded(selectedCellIndex: Int)
    func manageTrackedCalculatorCellsAppearence(selectedCellIndex: Int)
    func reselectOperator(operator_: CalculatorCell.Operator)
    func toggleClearCellValueIfNeeded()
    func toggleSecondSetOfFunctions()
    func toggleSIUnit()
}
