//
//  CalculatorCollectionViewCellModel.swift
//  iPhoneCalculatorRebuild
//
//  Created by Alfredo Colon on 3/14/21.
//  Copyright © 2021 Alfredo Colon. All rights reserved.
//

import Foundation

class CalculatorCollectionViewCellModel: Hashable {
	
	//MARK: - Properties
	
	var calculatorCell: CalculatorCell!
	var cellIsSelected: Bool = false
	var delegate: CalculatorCollectionViewCell?
	let identifier: UUID

	//MARK: - Init
	
	init(_ calculatorCell: CalculatorCell) {
		self.calculatorCell = calculatorCell
		
		self.identifier = UUID()
	}
	
	//MARK: - Hashable Protocol Methods
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(identifier)
	}
	
	static func == (lhs: CalculatorCollectionViewCellModel, rhs: CalculatorCollectionViewCellModel) -> Bool {
		return lhs.identifier == rhs.identifier
	}

	//MARK: - Methods
	
	func toggleCalculatorCellValue() {
		guard let calculatorCell = self.calculatorCell.toggledValue else { return }
		
		self.calculatorCell = calculatorCell
	}
}

