//
//  ScientificCalculatorCollectionView.swift
//  iPhoneCalculatorRebuild
//
//  Created by Alfredo Colon on 5/25/20.
//  Copyright © 2020 Alfredo Colon. All rights reserved.
//

import UIKit

class ScientificCalculatorCollectionView: UICollectionView, ManageScientificCalculatorCollectionViewCells, RoundScientificCalculatorCollectionViewCells, SyncScientificCalculatorCollectionViewCells {

    //MARK: - Properties
    
    var trackedViewCells: [Int : CalculatorCollectionViewCell] = [ : ]
    var viewControllerDelegate: CalculatorViewController!
    
    //MARK: - Init
    
    init(viewController: CalculatorViewController) {
        let compositionalLayout = ScientificCalculator.compositionalLayout
        super.init(frame: viewController.view.frame, collectionViewLayout: compositionalLayout)
        self.viewControllerDelegate = viewController
        self.setupProperties()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Init Helper Methods
    
    private func setupProperties() {
        self.allowsMultipleSelection = false
        self.backgroundColor = UIColor.black
        self.dataSource = viewControllerDelegate
        self.delegate = viewControllerDelegate
        self.register(CalculatorCollectionViewCell.self, forCellWithReuseIdentifier: ScientificCalculator.reuseIdentifier)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    //MARK: - LayoutMarginsDidChange
    
    override func layoutMarginsDidChange() {
        self.isHidden = Calculators.active == .Scientific ? false : true
    }
    
    //MARK: - LayoutSubviews
    
    override func layoutSubviews() {
        guard Calculators.active == .Scientific else { return }

        if self.visibleCells.count != 49 {
            self.viewControllerDelegate.constraints.deactivatePostScientificCollectionViewLoadingConstraints()
            super.layoutSubviews()
            self.roundCalculatorCellCorners()
        }
        
        self.viewControllerDelegate.constraints!.activatePostScientificCollectionViewLoadingConstraints()
        
        self.viewControllerDelegate.labelView.outputLabel.updateText()
        
        self.syncCalculators()
    }

    //MARK: - Manage Cells

    func deselectAllCellsThatAppearToBeSelectedIfNeeded() {
        for cell in self.trackedViewCells.values {
            if cell.appearsToBeSelected {
                cell.appearsToBeSelected = false
            }
        }
    }
    
    func deselectFunctionWithTwoInputsIfNeeded(selectedCellIndex: Int) {
        guard self.trackedViewCells.count == 49 else { return }
        
        let functionWithTwoInputsCellIndexes: [Int] = [13, 14, 23, 24, 35]
        
        for index in functionWithTwoInputsCellIndexes {
            if selectedCellIndex != index {
                if self.trackedViewCells[index]!.appearsToBeSelected {
                    self.trackedViewCells[index]!.appearsToBeSelected = false
                }
            }
        }
    }
    
    func deselectOperatorIfNeeded(selectedCellIndex: Int) {
        let additionCell: CalculatorCollectionViewCell! = self.trackedViewCells[39]
        let divisionCell: CalculatorCollectionViewCell! = self.trackedViewCells[9]
        let multiplicationCell: CalculatorCollectionViewCell! = self.trackedViewCells[19]
        let subtractionCell: CalculatorCollectionViewCell! = self.trackedViewCells[29]
        
        if selectedCellIndex != 39 && additionCell.appearsToBeSelected {
            additionCell.appearsToBeSelected = false
        }
        if selectedCellIndex != 9 && divisionCell.appearsToBeSelected {
            divisionCell.appearsToBeSelected = false
        }
        if selectedCellIndex != 19 && multiplicationCell.appearsToBeSelected {
            multiplicationCell.appearsToBeSelected = false
        }
        if selectedCellIndex != 29 && subtractionCell.appearsToBeSelected {
            subtractionCell.appearsToBeSelected = false
        }
    }
    
    func manageTrackedCalculatorCellsAppearence(selectedCellIndex: Int) {
        guard self.visibleCells.count == 49 else { return }

        let selectedCell: CalculatorCollectionViewCell! = self.trackedViewCells[selectedCellIndex]

        switch selectedCell.calculatorCell {
        case .clear(let clearType):
            switch clearType {
            case .AllClear:
                return self.deselectAllCellsThatAppearToBeSelectedIfNeeded()
            case .ClearEntry:
                 return selectedCell.toggleCalculatorCellValue()
            }
        case .decimal, .digit, .constant, .memoryRecall:
            self.toggleClearCellValueIfNeeded()
            self.deselectOperatorIfNeeded(selectedCellIndex: selectedCellIndex)
            self.deselectFunctionWithTwoInputsIfNeeded(selectedCellIndex: selectedCellIndex)
        case .equal:
            self.deselectAllCellsThatAppearToBeSelectedIfNeeded()
        case .operator_:
            self.deselectFunctionWithTwoInputsIfNeeded(selectedCellIndex: selectedCellIndex)
            self.deselectOperatorIfNeeded(selectedCellIndex: selectedCellIndex)
            selectedCell.appearsToBeSelected = true
        case .siUnit:
            self.toggleSIUnit()
        case .toggleSecondSetOfFunctions:
            self.toggleSecondSetOfFunctions()
            selectedCell.appearsToBeSelected.toggle()
        default:
            break
        }
        
        if selectedCell.calculatorCell.isFunctionWithTwoInputs {
            self.deselectOperatorIfNeeded(selectedCellIndex: selectedCellIndex)
            self.deselectFunctionWithTwoInputsIfNeeded(selectedCellIndex: selectedCellIndex)
            selectedCell.appearsToBeSelected = true
        }
    }
    
    func reselectOperator(operator_: CalculatorCell.Operator) {
        switch operator_ {
        case .Addition:
            let additionCell: CalculatorCollectionViewCell! = self.trackedViewCells[39]
            additionCell.isHighlighted = true
            additionCell.appearsToBeSelected = true
        case .Division:
            let divisionCell: CalculatorCollectionViewCell! = self.trackedViewCells[9]
            divisionCell.isHighlighted = true
            divisionCell.appearsToBeSelected = true
        case .Multiplication:
            let multiplicationCell: CalculatorCollectionViewCell! = self.trackedViewCells[19]
            multiplicationCell.isHighlighted = true
            multiplicationCell.appearsToBeSelected = true
        case .Subtraction:
            let subtractionCell: CalculatorCollectionViewCell! = self.trackedViewCells[29]
            subtractionCell.isHighlighted = true
            subtractionCell.appearsToBeSelected = true
        }
    }
    
    func toggleClearCellValueIfNeeded() {
        let clearCell: CalculatorCollectionViewCell! = self.trackedViewCells[6]
        
        switch clearCell.calculatorCell {
        case .clear(let clearType):
            if clearType == .AllClear {
                clearCell.toggleCalculatorCellValue()
            }
        default:
            break
        }
    }
    
    func toggleSecondSetOfFunctions() {
        let cell14: CalculatorCollectionViewCell! = self.trackedViewCells[14]
        let cell15: CalculatorCollectionViewCell! = self.trackedViewCells[15]
        let cell24: CalculatorCollectionViewCell! = self.trackedViewCells[24]
        let cell25: CalculatorCollectionViewCell! = self.trackedViewCells[25]
        let cell31: CalculatorCollectionViewCell! = self.trackedViewCells[31]
        let cell32: CalculatorCollectionViewCell! = self.trackedViewCells[32]
        let cell33: CalculatorCollectionViewCell! = self.trackedViewCells[33]
        let cell41: CalculatorCollectionViewCell! = self.trackedViewCells[41]
        let cell42: CalculatorCollectionViewCell! = self.trackedViewCells[42]
        let cell43: CalculatorCollectionViewCell! = self.trackedViewCells[43]
        
        cell14.toggleCalculatorCellValue()
        cell15.toggleCalculatorCellValue()
        cell24.toggleCalculatorCellValue()
        cell25.toggleCalculatorCellValue()
        cell31.toggleCalculatorCellValue()
        cell32.toggleCalculatorCellValue()
        cell33.toggleCalculatorCellValue()
        cell41.toggleCalculatorCellValue()
        cell42.toggleCalculatorCellValue()
        cell43.toggleCalculatorCellValue()
        
        //Deselect logy if needed()
        
        if cell24.appearsToBeSelected == true {
            cell24.appearsToBeSelected.toggle()
        }
    }
    
    func toggleSIUnit() {
        let siUnitCell: CalculatorCollectionViewCell! = self.trackedViewCells[40]
        
        siUnitCell.toggleCalculatorCellValue()
        
        switch siUnitCell.calculatorCell {
        case .siUnit(let siUnit):
            self.viewControllerDelegate.labelView.siUnitLabel.text = siUnit.siUnitLabelText
        default:
            break
        }
    }

    //MARK: - Round Corners

    func roundCalculatorCellCorners() {
        let cells = self.trackedViewCells.values
        for cell in cells {
            cell.layer.cornerRadius = cell.frame.height / 2
            cell.layer.masksToBounds = true
        }
    }

    //MARK: - Sync Calculators

    func syncCalculators() {
        guard self.trackedViewCells.count == 49 else { return }
        guard let standardCalculatorCells = self.viewControllerDelegate.standardCalculatorCollectionView?.trackedViewCells else { return }
        guard standardCalculatorCells.count == 19 else { return }

        //Sync operators
        let scientificCalculatorAdditionCell: CalculatorCollectionViewCell! = self.trackedViewCells[39]
        let scientificCalculatorDivisionCell: CalculatorCollectionViewCell! = self.trackedViewCells[9]
        let scientificCalculatorMultiplicationCell: CalculatorCollectionViewCell! = self.trackedViewCells[19]
        let scientificCalculatorSubtractionCell: CalculatorCollectionViewCell! = self.trackedViewCells[29]
        let standardCalculatorAdditionCell: CalculatorCollectionViewCell! = standardCalculatorCells[15]
        let standardCalculatorDivisionCell: CalculatorCollectionViewCell! = standardCalculatorCells[3]
        let standardCalculatorMultiplicationCell: CalculatorCollectionViewCell! = standardCalculatorCells[7]
        let standardCalculatorSubtractionCell: CalculatorCollectionViewCell! = standardCalculatorCells[11]
        scientificCalculatorAdditionCell.appearsToBeSelected = standardCalculatorAdditionCell.appearsToBeSelected
        scientificCalculatorDivisionCell.appearsToBeSelected = standardCalculatorDivisionCell.appearsToBeSelected
        scientificCalculatorMultiplicationCell.appearsToBeSelected = standardCalculatorMultiplicationCell.appearsToBeSelected
        scientificCalculatorSubtractionCell.appearsToBeSelected = standardCalculatorSubtractionCell.appearsToBeSelected
        
        //Sync clearCells
        let scientificCalculatorClearCell: CalculatorCollectionViewCell! = self.trackedViewCells[6]
        let standardCalculatorClearCell: CalculatorCollectionViewCell! = standardCalculatorCells[0]
        scientificCalculatorClearCell.calculatorCell = standardCalculatorClearCell.calculatorCell
    }
}
