//
//  StandardCalculatorCollectionView.swift
//  iPhoneCalculatorRebuild
//
//  Created by Alfredo Colon on 5/25/20.
//  Copyright © 2020 Alfredo Colon. All rights reserved.
//

import UIKit

class StandardCalculatorCollectionView: UICollectionView, ManageStandardCalculatorCollectionViewCells, RoundStandardCalculatorCollectionViewCells, SyncStandardCalculatorCollectionViewCells {
    
    //MARK: - Properties
    
    var trackedViewCells: [Int : CalculatorCollectionViewCell] = [ : ]
    var viewControllerDelegate: CalculatorViewController!
    
    //MARK: - Init
    
    init(viewController: CalculatorViewController) {
        let compositionalLayout = StandardCalculator.compositionalLayout
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
        self.register(CalculatorCollectionViewCell.self, forCellWithReuseIdentifier: StandardCalculator.reuseIdentifier)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: - LayoutMarginsDidChange
    
    override func layoutMarginsDidChange() {
        self.isHidden = Calculators.active == .Standard ? false : true
    }
    
    //MARK: - LayoutSubviews
    
    override func layoutSubviews() {
        guard Calculators.active == .Standard else { return }

        if self.visibleCells.count != 19 {
            self.viewControllerDelegate.constraints.deactivatePostStandardCollectionViewLoadingConstraints()
            super.layoutSubviews()
            self.roundCalculatorCellCorners()
        }
        
        self.viewControllerDelegate.constraints.activatePostStandardCollectionViewLoadingConstraints()
        
        self.viewControllerDelegate.labelView.outputLabel.updateText()
        
        self.syncCalculators()
    }

    //MARK: - Manage Cells

    func deselectAllCellsThatAppearToBeSelectedIfNeeded() {
        for cell in self.trackedViewCells.values {
            if cell.appearsToBeSelected {
                cell.appearsToBeSelected.toggle()
            }
        }
    }
    
    func deselectOperatorIfNeeded(selectedCellIndex: Int) {
        let additionCell: CalculatorCollectionViewCell! = self.trackedViewCells[15]
        let divisionCell: CalculatorCollectionViewCell! = self.trackedViewCells[3]
        let multiplicationCell: CalculatorCollectionViewCell! = self.trackedViewCells[7]
        let subtractionCell: CalculatorCollectionViewCell! = self.trackedViewCells[11]
        
        if selectedCellIndex != 15 && additionCell.appearsToBeSelected {
            additionCell.appearsToBeSelected = false
        }
        if selectedCellIndex != 3 && divisionCell.appearsToBeSelected {
            divisionCell.appearsToBeSelected = false
        }
        if selectedCellIndex != 7 && multiplicationCell.appearsToBeSelected {
            multiplicationCell.appearsToBeSelected = false
        }
        if selectedCellIndex != 11 && subtractionCell.appearsToBeSelected {
            subtractionCell.appearsToBeSelected = false
        }
    }
    
    func manageTrackedCalculatorCellsAppearence(selectedCellIndex: Int) {
        guard self.visibleCells.count == 19 else { return }
        
        let selectedCell: CalculatorCollectionViewCell! = self.trackedViewCells[selectedCellIndex]
        
        switch selectedCell.calculatorCell {
        case .clear(let clearType):
            switch clearType {
            case .AllClear:
                return self.deselectAllCellsThatAppearToBeSelectedIfNeeded()
            case .ClearEntry:
                 return selectedCell.toggleCalculatorCellValue()
            }
        case .decimal, .digit:
            self.toggleClearCellValueIfNeeded()
            self.deselectOperatorIfNeeded(selectedCellIndex: selectedCellIndex)
        case .operator_:
            self.deselectOperatorIfNeeded(selectedCellIndex: selectedCellIndex)
            selectedCell.appearsToBeSelected = true
        case .equal:
            self.deselectAllCellsThatAppearToBeSelectedIfNeeded()
        default:
            break
        }
    }
    
    func reselectOperator(operator_: CalculatorCell.Operator) {
        switch operator_ {
        case .Addition:
            let additionCell: CalculatorCollectionViewCell! = self.trackedViewCells[15]
            additionCell.isHighlighted = true
            additionCell.appearsToBeSelected = true
        case .Division:
            let divisionCell: CalculatorCollectionViewCell! = self.trackedViewCells[3]
            divisionCell.isHighlighted = true
            divisionCell.appearsToBeSelected = true
        case .Multiplication:
            let multiplicationCell: CalculatorCollectionViewCell! = self.trackedViewCells[7]
            multiplicationCell.isHighlighted = true
            multiplicationCell.appearsToBeSelected = true
        case .Subtraction:
            let subtractionCell: CalculatorCollectionViewCell! = self.trackedViewCells[11]
            subtractionCell.isHighlighted = true
            subtractionCell.appearsToBeSelected = true
        }
    }
    
    func toggleClearCellValueIfNeeded() {
        let clearCell: CalculatorCollectionViewCell! = self.trackedViewCells[0]
        
        switch clearCell.calculatorCell {
        case .clear(let clearType):
            if clearType == .AllClear {
                clearCell.toggleCalculatorCellValue()
            }
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
        guard self.trackedViewCells.count == 19 else { return }
        guard let scientificCalculatorCells = self.viewControllerDelegate.scientificCalculatorCollectionView?.trackedViewCells else { return }
        guard scientificCalculatorCells.count == 49 else { return }

        //Sync operators
        let scientificCalculatorAdditionCell: CalculatorCollectionViewCell! = scientificCalculatorCells[39]
        let scientificCalculatorDivisionCell: CalculatorCollectionViewCell! = scientificCalculatorCells[9]
        let scientificCalculatorMultiplicationCell: CalculatorCollectionViewCell! = scientificCalculatorCells[19]
        let scientificCalculatorSubtractionCell: CalculatorCollectionViewCell! = scientificCalculatorCells[29]
        let standardCalculatorAdditionCell: CalculatorCollectionViewCell! = self.trackedViewCells[15]
        let standardCalculatorDivisionCell: CalculatorCollectionViewCell! = self.trackedViewCells[3]
        let standardCalculatorMultiplicationCell: CalculatorCollectionViewCell! = self.trackedViewCells[7]
        let standardCalculatorSubtractionCell: CalculatorCollectionViewCell! = self.trackedViewCells[11]
        standardCalculatorAdditionCell.appearsToBeSelected = scientificCalculatorAdditionCell.isSelected
        standardCalculatorDivisionCell.appearsToBeSelected = scientificCalculatorDivisionCell.isSelected
        standardCalculatorMultiplicationCell.appearsToBeSelected = scientificCalculatorMultiplicationCell.isSelected
        standardCalculatorSubtractionCell.appearsToBeSelected = scientificCalculatorSubtractionCell.isSelected
        
        //Sync clearCells
        let scientificCalculatorClearCell: CalculatorCollectionViewCell! = self.viewControllerDelegate.scientificCalculatorCollectionView.trackedViewCells[6]
        let standardCalculatorClearCell: CalculatorCollectionViewCell! = self.trackedViewCells[0]
        standardCalculatorClearCell.calculatorCell = scientificCalculatorClearCell.calculatorCell
    }
}
