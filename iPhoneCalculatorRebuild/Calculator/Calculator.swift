//
//  Calculator.swift
//  iPhoneCalculatorRebuild
//
//  Created by Alfredo Colon on 5/26/20.
//  Copyright © 2020 Alfredo Colon. All rights reserved.
//

import UIKit

enum Calculator {
	case scientific
	case standard
}

struct Calculators {
	
	// MARK: - Properties
	
	static var active: Calculator = Calculator.standard
	static var scientific: ScientificCalculator = ScientificCalculator()
	static var standard: StandardCalculator = StandardCalculator()
	
	
	// MARK: - Methods
	
	static func layout() -> UICollectionViewCompositionalLayout {
		switch Calculators.active {
		case .scientific:
			guard let layouts = Calculators.scientific.layouts else { return ScientificCalculator.Layouts.test }
			return layouts.actual
		case .standard:
			guard let layouts = Calculators.standard.layouts else { return StandardCalculator.Layouts.test }
			return layouts.actual
		}
	}
	
	static func calculatorAreSetUp() -> Bool {
		guard Calculators.scientific.layouts != nil else { return false }
		guard Calculators.scientific.objectSizes != nil else { return false }
		guard Calculators.standard.layouts != nil else { return false }
		guard Calculators.standard.objectSizes != nil else { return false }
		return true
	}
	
	static func setupCalculator(vc: CalculatorViewController) {
		switch Calculators.active {
		case .scientific:
			let objectSizes = ScientificCalculator.ObjectSizes(view: vc.view)
			Calculators.scientific.objectSizes = objectSizes
			Calculators.scientific.layouts = ScientificCalculator.Layouts(objectSizes: objectSizes)
			Calculators.scientific.constraints = ScientificCalculator.Constraints(objectSizes: objectSizes, vc: vc)
		case .standard:
			let objectSizes = StandardCalculator.ObjectSizes(view: vc.view)
			Calculators.standard.objectSizes = objectSizes
			Calculators.standard.layouts = StandardCalculator.Layouts(objectSizes: objectSizes)
			Calculators.standard.constraints = StandardCalculator.Constraints(objectSizes: objectSizes, vc: vc)
		}
	}
	
	
	static func activate() {
		switch Calculators.active {
		case .scientific:
			Calculators.scientific.constraints?.activate()
		case .standard:
			Calculators.standard.constraints?.activate()
		}
	}
	
	static func deactivate() {
		switch Calculators.active {
		case .scientific:
			Calculators.scientific.constraints?.deactivate()
		case .standard:
			Calculators.standard.constraints?.deactivate()
		}
	}
	
}
