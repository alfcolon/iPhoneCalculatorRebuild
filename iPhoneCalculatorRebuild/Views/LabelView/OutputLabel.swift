//
//  OutputLabel.swift
//  iPhoneCalculatorRebuild
//
//  Created by Alfredo Colon on 5/25/20.
//  Copyright © 2020 Alfredo Colon. All rights reserved.
//

import UIKit

class OutputLabel: UILabel {
	
	//MARK: - Properties
	
//    var dummyLabel: DummyLabel!
	var outputTerm: Term!
	
	//MARK: - Init

	override init(frame: CGRect) {
		super.init(frame: frame)

		self.setupProperties()
		AccessibilityObjects.shared.setup(outputLabel: self)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Init Helper Method

	
	private func setupProperties() {
		self.outputTerm = Term.ThisTermNeedsToBeSet
		self.textAlignment = .right
		self.translatesAutoresizingMaskIntoConstraints = false
		
		self.text = "0"
		self.font = Fonts.SFProTextRegular(45).font
		self.textColor = .white
		self.layer.cornerRadius = 10
		self.layer.masksToBounds = true
		
		self.adjustsFontSizeToFitWidth = true
		self.allowsDefaultTighteningForTruncation = true
		self.minimumScaleFactor = 0.5
	}

	//MARK: - Methods
	
	func updateText() {
		switch Calculators.active {
		case .scientific:
			self.font = Fonts.SFProTextRegular(50).font
			self.text = Calculators.scientific.formatTermNumber(term: self.outputTerm)
			self.backgroundColor = .clear
		case .standard:
			self.font = Fonts.SFProDisplayThin(95).font
			let text = Calculators.standard.formatTermNumber(term: self.outputTerm)
			self.text = text
			self.backgroundColor = .clear
		}
	}
	
	//MARK: - Padding
	
	let padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

	override func drawText(in rect: CGRect) {
		super.drawText(in: rect.inset(by: padding))
	}

	override var intrinsicContentSize : CGSize {
		let superContentSize = super.intrinsicContentSize
		let width = superContentSize.width + padding.left + padding.right
		let heigth = superContentSize.height + padding.top + padding.bottom
		return CGSize(width: width, height: heigth)
	}
}
