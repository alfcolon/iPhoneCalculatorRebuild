//
//  CalculatorViewController.swift
//  iPhoneCalculatorRebuild
//
//  Created by Alfredo Colon on 5/25/20.
//  Copyright © 2020 Alfredo Colon. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    //MARK: - Properties
    
    var calculatorBrain: CalculatorBrain!
    var constraints: Constraints!
    var labelView: LabelView!
    var scientificCalculatorCollectionView: ScientificCalculatorCollectionView!
    var standardCalculatorCollectionView: StandardCalculatorCollectionView!
    
    //MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1.Update Properties
        self.view.backgroundColor = .black
        self.labelView = LabelView(frame: self.view.frame)
        self.scientificCalculatorCollectionView = ScientificCalculatorCollectionView(viewController: self)
        self.standardCalculatorCollectionView = StandardCalculatorCollectionView(viewController: self)
        
        //2.Add Subviews
        self.view.addSubview(self.scientificCalculatorCollectionView)
        self.view.addSubview(self.standardCalculatorCollectionView)
        self.view.addSubview(self.labelView)

        //3.Set up constraints
        self.constraints = Constraints(viewControllerDelegate: self)
        self.constraints.activateUniversalConstraints()
        self.labelView.delegate = self
        
        //4.Setup CalculatorBrain
        self.calculatorBrain = CalculatorBrain(outputLabelDelegate: self.labelView.outputLabel)
    }

    override func viewLayoutMarginsDidChange() {
        //1.Deactive orientation-specific constraints if needed
        constraints.deactivateOrientationConstraints()
        constraints.deactiveatePostCollectionViewLoadingConstraints()
        
        //2.Update current calculator
        Calculators.active = self.view.frame.height < self.view.frame.width ? .Scientific : .Standard

        //3.Call layoutMarginsDidChange for subviews
        self.constraints.activateOrientationConstraints()
        self.labelView.layoutMarginsDidChange()
        self.scientificCalculatorCollectionView.layoutMarginsDidChange()
        self.standardCalculatorCollectionView.layoutMarginsDidChange()
    }
}

//MARK: - UICollectionViewDataSource

extension CalculatorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.scientificCalculatorCollectionView:
            return ScientificCalculator.calculatorCells.count
        case self.standardCalculatorCollectionView:
            return StandardCalculator.calculatorCells.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.scientificCalculatorCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScientificCalculator.reuseIdentifier, for: indexPath) as? CalculatorCollectionViewCell else { return UICollectionViewCell() }
            if self.scientificCalculatorCollectionView.trackedViewCells.count == ScientificCalculator.calculatorCells.count {
                cell.calculatorCell = self.scientificCalculatorCollectionView.trackedViewCells[indexPath.item]!.calculatorCell
                self.scientificCalculatorCollectionView.trackedViewCells[indexPath.item] = cell
            }
            else {
                cell.calculatorCell = ScientificCalculator.calculatorCells[indexPath.item]
                self.scientificCalculatorCollectionView.trackedViewCells[indexPath.item] = cell
            }
            
            return cell
        case self.standardCalculatorCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StandardCalculator.reuseIdentifier, for: indexPath) as? CalculatorCollectionViewCell else { return UICollectionViewCell() }
            if self.standardCalculatorCollectionView.trackedViewCells.count == StandardCalculator.calculatorCells.count {
                cell.calculatorCell = self.standardCalculatorCollectionView.trackedViewCells[indexPath.item]!.calculatorCell
                self.standardCalculatorCollectionView.trackedViewCells[indexPath.item] = cell
            }
            else {
                cell.calculatorCell = StandardCalculator.calculatorCells[indexPath.item]
                self.standardCalculatorCollectionView.trackedViewCells[indexPath.item] = cell
            }
            
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

//MARK: - UICollectionViewDelegate

extension CalculatorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //1.Set up variable for calculatorCell to be handled by CalculatorBrain
        var calculatorCell: CalculatorCell!
        
        //2.Take care of any view realted actions
        switch collectionView {
        case self.scientificCalculatorCollectionView:
            calculatorCell = self.scientificCalculatorCollectionView.trackedViewCells[indexPath.item]!.calculatorCell
            self.scientificCalculatorCollectionView.manageTrackedCalculatorCellsAppearence(selectedCellIndex: indexPath.item)
        case self.standardCalculatorCollectionView:
            calculatorCell = self.standardCalculatorCollectionView.trackedViewCells[indexPath.item]!.calculatorCell
            self.standardCalculatorCollectionView.manageTrackedCalculatorCellsAppearence(selectedCellIndex: indexPath.item)
        default:
            break
        }
        
        //Return early if outputLabel is Error'd out
        var clearCell: Bool {
            switch calculatorCell {
            case .clear(let clearType):
                return clearType == .AllClear
            default:
                return false
            }
        }
        
        if self.labelView.outputLabel.text == "Error" {
            guard clearCell == true else { return }
        }
        
        
        //3.Send calculatorCell sent off to calculatorBrain
        print("calculatorCell:\t\(calculatorCell.attributedString.string)")
        self.calculatorBrain.evaluateSelectedCalculatorCell(calculatorCell)
        
        //4.Update outputLabel text
        self.labelView.outputLabel.updateText()
    }
}
