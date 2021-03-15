//
//  CalculatorCollectionView.swift
//  iPhoneCalculatorRebuild
//
//  Created by Alfredo Colon on 3/14/21.
//  Copyright © 2021 Alfredo Colon. All rights reserved.
//

import UIKit

class CalculatorCollectionView: UICollectionView {

	// MARK:  - Init
	
	init(vc: CalculatorViewController, layout: UICollectionViewCompositionalLayout) {
		super.init(frame: vc.view.frame, collectionViewLayout: layout)
		self.updateProperties(vc: vc)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	// MARK: - Methods
	
	func updateProperties(vc: CalculatorViewController) {
		self.translatesAutoresizingMaskIntoConstraints = false
		self.isScrollEnabled = false
		self.backgroundColor = .black
		self.register(CalculatorCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
		self.delegate = vc
		AccessibilityObjects.shared.setup(collectionView: self)
		
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		self.roundCalculatorCellCorners()
	}
	
	func roundCalculatorCellCorners() {
		let cells = self.visibleCells
		for cell in cells {
			cell.layer.cornerRadius = cell.frame.height / 2
			cell.layer.masksToBounds = true
		}
	}

}
