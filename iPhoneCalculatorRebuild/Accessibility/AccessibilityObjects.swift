//
//  AccessibilityObjects.swift
//  iPhoneCalculatorRebuild
//
//  Created by Alfredo Colon on 3/14/21.
//  Copyright © 2021 Alfredo Colon. All rights reserved.
//

import UIKit

class AccessibilityObjects {
	enum Objects {
		case collectionView
		case labelView
		case menuController
		case outputLabel
		case viewCells
	}

	
	// MARK: - Singleton
	
	static let shared = AccessibilityObjects()
	
	// MARK: - Properties
	
	var labelView: LabelView!
	var collectionView: CalculatorCollectionView!
	
	// MARK: - LabelView
	
	func update(labelView: LabelView) {
		self.labelView.accessibilityLabel = "result" + labelView.outputLabel.attributedText!.string
	}
	
	func setup(labelView: LabelView) {
		labelView.isAccessibilityElement = true
		labelView.accessibilityIdentifier = "labelView"
	}
	
	// MARK: - CollectionView
	
	func setup(collectionView: CalculatorCollectionView) {
		collectionView.isAccessibilityElement = false
		collectionView.accessibilityIdentifier = "collectionView"
	}
	
	// MARK: - Output Label
	
	func update(outputLabel: OutputLabel) {
		outputLabel.accessibilityLabel = "result" + self.labelView.outputLabel.attributedText!.string
	}
	
	func setup(outputLabel: OutputLabel) {
		outputLabel.accessibilityIdentifier = "outputLabel"
		
	}
	
	// MARK: - View Cell
	
	func setup(viewCell: CalculatorCollectionViewCell) {
		viewCell.isAccessibilityElement = true
		viewCell.accessibilityLabel = viewCell.viewModel.calculatorCell.accessibilityLabel
		viewCell.accessibilityIdentifier = "deselected"
	}
	
	func update(viewCell: CalculatorCollectionViewCell) {
		viewCell.accessibilityIdentifier = viewCell.viewModel.cellIsSelected ? "selected" : "deselected"
	}
	
	// MARK: - Menu Controller
	
	func setup(menuController: MenuController) {
		menuController.isAccessibilityElement = false
		menuController.accessibilityValue = "menu controller"
	}
	
	
}
