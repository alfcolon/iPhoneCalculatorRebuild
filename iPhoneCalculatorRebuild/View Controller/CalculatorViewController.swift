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
        self.constraints.deactivateOrientationConstraints()
        self.constraints.deactiveatePostCollectionViewLoadingConstraints()
        
        //2.Update current calculator
        Calculators.active = self.view.frame.height < self.view.frame.width ? .Scientific : .Standard

        //3.Update active calculator-specific constraints
        self.constraints.activateOrientationConstraints()
        
        //4.Call layoutMarginsDidChange for subviews
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
        guard let calculatorCollectionViewCell = collectionView.cellForItem(at: indexPath) as? CalculatorCollectionViewCell else { return }

        //Avoid updating an "Error" unless its to clear it out
        if self.labelView.outputLabel.text == "Error" && calculatorCollectionViewCell.calculatorCell.isClear == true { return }

        //2.Take care of any view realted actions
        switch collectionView {
        case self.scientificCalculatorCollectionView:
            self.scientificCalculatorCollectionView.manageTrackedCalculatorCellsAppearence(selectedCellIndex: indexPath.item)
        case self.standardCalculatorCollectionView:
            self.standardCalculatorCollectionView.manageTrackedCalculatorCellsAppearence(selectedCellIndex: indexPath.item)
        default:
            break
        }

        //3.Send calculatorCell sent off to calculatorBrain
        print("calculatorCell:\t\(calculatorCollectionViewCell.calculatorCell.attributedString.string)")
        self.calculatorBrain.evaluateSelectedCalculatorCell(calculatorCollectionViewCell.calculatorCell)

        //4.Update outputLabel text
        self.labelView.outputLabel.updateText()
    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        //1.Set up variable for calculatorCell to be handled by CalculatorBrain
//        guard let calculatorCollectionViewCell = collectionView.cellForItem(at: indexPath) as? CalculatorCollectionViewCell else { return }
//
//        //Avoid updating an "Error" unless its to clear it out
//        if self.labelView.outputLabel.text == "Error" && calculatorCollectionViewCell.calculatorCell.isClear == false { return }
//
//        //2.Take care of any view realted actions
//        let dispatch = DispatchQueue(label: "Update Solving Logic")
//        dispatch.async {
//            self.calculatorBrain.evaluateSelectedCalculatorCell(calculatorCollectionViewCell.calculatorCell)
//            DispatchQueue.main.async {
//                self.labelView.outputLabel.updateText()
//            }
//            print("updated cells")
//        }
//
//        switch collectionView {
//        case self.scientificCalculatorCollectionView:
//            self.scientificCalculatorCollectionView.manageTrackedCalculatorCellsAppearence(selectedCellIndex: indexPath.item)
//        case self.standardCalculatorCollectionView:
//            self.standardCalculatorCollectionView.manageTrackedCalculatorCellsAppearence(selectedCellIndex: indexPath.item)
//        default:
//            break
//        }
////        let updateCells = DispatchQueue.init(label: "updateCollectionViewCells")
//        let updateSolvingLogic = BlockOperation {
//
//            print("updated solving logic")
//        }
//
//
////        //3.Send calculatorCell sent off to calculatorBrain
////        print("calculatorCell:\t\(calculatorCollectionViewCell.calculatorCell.attributedString.string)")
////        let updateLabel = BlockOperation {  }
////        updateLabel.addDependency(updateSolvingLogic)
//
////        let operationQueue = OperationQueue()
////        operationQueue.addOperations([updateSolvingLogic, updateCollectionViewCells, updateLabel], waitUntilFinished: false)
//
//        print("updated label")
//    }
}
