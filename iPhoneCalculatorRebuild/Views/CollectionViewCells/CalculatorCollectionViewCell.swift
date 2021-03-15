//
//  CalculatorCollectionViewCell.swift
//  iPhoneCalculatorRebuild
//
//  Created by Alfredo Colon on 5/25/20.
//  Copyright © 2020 Alfredo Colon. All rights reserved.
//

import UIKit

class CalculatorCollectionViewCell: UICollectionViewCell {
	
	//MARK: - Properties
	
	var viewModel: CalculatorCollectionViewCellModel!
	var label: CalculatorCollectionViewCellLabel!
	
	//MARK: - isHiglighted
	
	override var isHighlighted: Bool {
		didSet {
			self.isHighlighted == true ?
				highlightCell(to: self.viewModel.calculatorCell.highlightColor, duration: 0.5, options: .curveEaseIn, view: self)
			:
			highlightCell(to: self.viewModel.calculatorCell.backgroundColor, duration: 0.5, options: .curveEaseOut, view: self)
		}
	}
	
	private func highlightCell(to color: UIColor, duration: TimeInterval, options: UIView.AnimationOptions, view: UIView) {
		UIView.animate(
			withDuration: duration,
			delay: 0,
			options: options,
			animations: { view.backgroundColor = color }
		)
	}
	
	func updateAppearenceForSelectedCell() {
		self.backgroundColor = self.viewModel.calculatorCell.selectedBackgroundColor
		self.label.textColor = self.viewModel.calculatorCell.selectedTextColor
		AccessibilityObjects.shared.update(viewCell: self)
		
	}
	
	func updateAppearenceForDeselectedCell() {
		self.backgroundColor = self.viewModel.calculatorCell.backgroundColor
		self.label.textColor = self.viewModel.calculatorCell.textColor
		AccessibilityObjects.shared.update(viewCell: self)
	}
	
	//MARK: - Init
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setupSubviews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Init Helper Method

	func setupSubviews() {
		self.label = CalculatorCollectionViewCellLabel(frame: self.frame)

		self.contentView.addSubview(label)

		self.label.activateConstraints()
	}

	//MARK: - Update Properties

	func updateProperties() {
		self.backgroundView = nil
		self.label.attributedText = self.viewModel.calculatorCell.attributedString
		AccessibilityObjects.shared.setup(viewCell: self)
		
		if self.viewModel.cellIsSelected {
			self.addSelectedRadicalViewIfNeeded()
			self.updateAppearenceForSelectedCell()
		}
		else {
			self.addDeselectedRadicalViewIfNeeded()
			self.updateAppearenceForDeselectedCell()
		}
	}
	
	func updateCenterX(itemWidth: CGFloat) {
		NSLayoutConstraint.deactivate([self.label.centerXConstraint])
		self.label.centerXConstraint = {
			if self.label.attributedText?.string == "0" {
				return self.label.centerXAnchor.constraint(equalTo: self.leadingAnchor, constant: itemWidth / 2)
			}
			return self.label.centerXAnchor.constraint(equalTo: self.centerXAnchor)
		}()
		NSLayoutConstraint.activate([self.label.centerXConstraint])
	}
	
	private func addDeselectedRadicalViewIfNeeded() {
		switch self.viewModel.calculatorCell {
		case .rootFunction:
			self.backgroundView = RadicalViewDeselected(frame: self.frame)
		default:
			break
		}
	}
	
	private func addSelectedRadicalViewIfNeeded() {
		switch self.viewModel.calculatorCell {
		case .rootFunction:
			self.backgroundView = RadicalViewSelected(frame: self.frame)
		default:
			break
		}
	}

	func toggleCalculatorCellValue() {
		guard let calculatorCellToggledValue = self.viewModel.calculatorCell.toggledValue else { return }
		
		self.viewModel.calculatorCell = calculatorCellToggledValue
	}
}
