//
//  LabelView.swift
//  iPhoneCalculatorRebuild
//
//  Created by Alfredo Colon on 6/12/20.
//  Copyright © 2020 Alfredo Colon. All rights reserved.
//

import UIKit

class LabelView: UIView, EditOutputLabelText, OutputLabelMenuController {
    
    //MARK: - Properties

    var delegate: CalculatorViewController!
    var menuController: MenuController!
    var outputLabel: OutputLabel!
    var siUnitLabel: SIUnitLabel!
    override var canBecomeFirstResponder: Bool { return true }

    //MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupProperties()
        self.setupSubviews()
        self.setupLongPressGesture()
        self.setupLeftSwipeGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Init Helper Methods

    private func setupProperties() {
        self.backgroundColor = .black
        self.becomeFirstResponder()
        self.isUserInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.menuController = MenuController()
    }
    
    private func setupSubviews() {
        self.outputLabel = OutputLabel(frame: self.frame)
        self.siUnitLabel = SIUnitLabel(frame: self.frame)
        
        self.addSubview(self.outputLabel)
        self.addSubview(self.siUnitLabel)
    }

    //MARK: - LayoutMarginsDidChange
    
    override func layoutMarginsDidChange() {
        self.siUnitLabel.isHidden = Calculators.active == .Scientific ? false : true
    }
    
    //MARK: - EditOutputLabelText
    
    @objc internal func deleteOutputLabelText(gesture: UIGestureRecognizer) {
        //1.Return early if outputTerm is not a mutableOperand
        var maybeMutableOperand: MutableOperand? {
            switch self.outputLabel.outputTerm! {
            case .mutableOperand(let mutableOperand):
                return mutableOperand
            default:
                return nil
            }
        }
        guard let mutableOperand = maybeMutableOperand else { return }
        
        //2.First check if the negative symbol should be removed
        let locationOfLeftSwipe = gesture.location(in: self.outputLabel)
        if locationOfLeftSwipe.x > 0 && locationOfLeftSwipe.y > 0 && mutableOperand.toggleSign && mutableOperand.fractionArray.isEmpty && mutableOperand.integerArray == ["0"] {
            mutableOperand.toggleSign.toggle()
        }
        
        //3.Otherwise, remove the last digit
        else {
            mutableOperand.removeLastDigit()
        }
        
        //4.Update text
        self.outputLabel.updateText()
        
        //5.Reanimate the operator if the mutable operand is 0
        if !mutableOperand.decimal && !mutableOperand.toggleSign && mutableOperand.fractionArray.isEmpty && mutableOperand.integerArray == ["0"] {
            let currentPrecedenceOperation: PrecedenceOperation! = self.delegate.calculatorBrain.arithmeticController.precedenceOperations[self.delegate.calculatorBrain.arithmeticController.parentheticalExpressionIndex]!.currentPrecedenceOperation
            guard let operator_: CalculatorCell.Operator = currentPrecedenceOperation.operator_ else { return }
            
            switch Calculators.active {
            case .Scientific:
                self.delegate.scientificCalculatorCollectionView.reselectOperator(operator_: operator_)
            case .Standard:
                self.delegate.standardCalculatorCollectionView.reselectOperator(operator_: operator_)
            }
        }
    }
    
    func setupLeftSwipeGesture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(deleteOutputLabelText))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.addGestureRecognizer(swipeLeft)
    }
    
    //MARK: - OutputLabelMenuController
    
    @objc internal func copyText() {
        guard self.outputLabel.text != "Error" else { return }
        guard let double = self.outputLabel.outputTerm.doubleValue else { return }

        self.menuController.copiedDouble = double

        self.menuController.pasteBoard.string = String(double)
    }

    @objc internal func pasteText() {
        guard self.menuController.copiedDouble != nil else { return }
        
        self.delegate.calculatorBrain.arithmeticController.addCalculatorEntry(double: self.menuController.copiedDouble)
//        self.outputLabel.outputTerm.updateTerm(to: self.menuController.copiedDouble)
        self.outputLabel.updateText()
    }

    func setupLongPressGesture() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(showTextEditingMenu))
        longPressedGesture.minimumPressDuration = 0.5
        self.addGestureRecognizer(longPressedGesture)
    }
    
    @objc internal func showTextEditingMenu(_ gesture: UILongPressGestureRecognizer) {
        guard !self.menuController.isMenuVisible else { return }

        let menuItemCopy = UIMenuItem(title: "Copy", action: #selector(copyText))
        let menuItemPaste = UIMenuItem(title: "Paste", action: #selector(pasteText))

        self.menuController.menuItems = self.menuController.copiedDouble == nil ? [menuItemCopy] : [menuItemCopy, menuItemPaste]
        self.menuController.showMenu(from: self.outputLabel, rect: self.outputLabel.bounds)

        self.outputLabel.backgroundColor = Colors.EerieBlackish.backgroundColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.outputLabel.backgroundColor = .clear

        self.menuController.hideMenu()
    }
}
