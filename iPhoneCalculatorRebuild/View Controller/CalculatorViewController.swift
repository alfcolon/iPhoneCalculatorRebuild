//
//  CalculatorViewController.swift
//  iPhoneCalculatorRebuild
//
//  Created by Alfredo Colon on 5/25/20.
//  Copyright © 2020 Alfredo Colon. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
	
	// MARK: - Properties
	
	var calculatorBrain: CalculatorBrain!
	var collectionView: CalculatorCollectionView!
	var labelView: LabelView!
	var dataContoller: CalculatorDatasourceController!
	var didappear: Bool = false
	
	// MARK: - View Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.setupProperties()
		
		self.setupSubviews()
		
		self.configureHeirarchy()
		
		self.dataContoller = CalculatorDatasourceController()
		self.dataContoller.setupDatasource(vc: self)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		self.didappear = true
		
		// Update calculator
		Calculators.active = self.view.frame.width > self.view.frame.height ? .scientific : .standard
		
		// Hide SIUnit label
		self.labelView.siUnitLabel.layoutMarginsDidChange()
		
		// Update Info and constraints if needed
		Calculators.setupCalculator(vc: self)
		
		// Activate constraints
		Calculators.activate()
		
		// Toggle between data sources
		self.dataContoller.setinitialDatasourceSnapshot()
		
		// Set Layout and reload
		let layout = Calculators.layout()
		
		// Force the collection view to load
		let group = DispatchGroup()
		DispatchQueue.main.async {
			group.enter()
			self.collectionView.setCollectionViewLayout(layout, animated: true)
			group.leave()
		}
		group.wait()
	
		self.calculatorBrain = CalculatorBrain(outputLabelDelegate: self.labelView.outputLabel)
		
		// Update outputLabel with outputTerm - this also updates the font
		self.labelView.outputLabel.updateText()
		
		// Update accessibility properties for labelView
//		AccessibilityObjects.shared.updateLabelView(vc: self)
	}

	override func viewLayoutMarginsDidChange() {
		// Avoid doind viewDidAppears job
		guard self.didappear == true else { return }
		
		// Deactivate constraints
		Calculators.deactivate()
		
		// Update active Calculator
		Calculators.active = view.frame.width > view.frame.height ? .scientific : .standard
		
		// Hide SIUnit label
		self.labelView.siUnitLabel.layoutMarginsDidChange()
		
		// Set up calc info if needed
		if Calculators.calculatorAreSetUp() == false {
			Calculators.setupCalculator(vc: self)
		}
		
		Calculators.activate()
		
		self.dataContoller.setinitialDatasourceSnapshot()
		
		// Set Layout and reload
		let layout = Calculators.layout()
		self.collectionView.setCollectionViewLayout(layout, animated: false)
		self.collectionView.reloadData()
		
		// Update outputLabel with outputTerm - this also updates the font
		self.labelView.outputLabel.updateText()
		
		// Update accessibility properties for labelView()
		
		// Announce the calculator type for voice over accessibility
		let text = Calculators.active == .scientific ? "Scientific" : "Standard"
		UIAccessibility.post(notification: .announcement, argument: text)
	}
	
	func setupProperties() {
		self.modalPresentationStyle = .fullScreen
		self.navigationItem.hidesBackButton = true
		self.view.backgroundColor = .black
		self.view.accessibilityIdentifier = "mainView"
	}
	
	func setupSubviews() {
		self.labelView = LabelView(frame: self.view.frame)
		self.labelView.delegate = self
		
		let layout = Calculators.layout()
		self.collectionView = CalculatorCollectionView(vc: self, layout: layout)
	}

	func configureHeirarchy() {
		self.view.addSubview(self.collectionView)
		self.view.addSubview(self.labelView)
		
		NSLayoutConstraint.activate([
			self.labelView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
			self.labelView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
			self.labelView.bottomAnchor.constraint(equalTo: self.collectionView.topAnchor),
			
			self.labelView.outputLabel.bottomAnchor.constraint(equalTo: self.labelView.bottomAnchor),
			
			self.labelView.siUnitLabel.bottomAnchor.constraint(equalTo: self.labelView.bottomAnchor),
			
			self.collectionView.topAnchor.constraint(equalTo: self.labelView.bottomAnchor),
			self.collectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
		])
	}
}

extension CalculatorViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt: IndexPath) -> Bool {
		guard let itemIdentifier = self.dataContoller.datasource.itemIdentifier(for: shouldSelectItemAt) else { return false }

		// Deselect
		if itemIdentifier.calculatorCell.deselectsSelectedCell {
			self.dataContoller.deselectIfNeeded(for: itemIdentifier.calculatorCell)
		}
		// Update AC/C
		if itemIdentifier.calculatorCell.toggleClearType {
			self.dataContoller.updateClearCellIfNeeded(for: itemIdentifier.calculatorCell)
		}
		// Select
		if itemIdentifier.calculatorCell.appearenceChangesWhenSelected {
			self.dataContoller.selectCell(for: itemIdentifier)
		}
		// SIUnit
		if itemIdentifier.calculatorCell.updatesSIUnitLabel {
			// Update view cell
			itemIdentifier.calculatorCell = itemIdentifier.calculatorCell.toggledValue!
			itemIdentifier.delegate?.updateProperties()
			// Update view
			self.labelView.siUnitLabel.updateText(string: itemIdentifier.calculatorCell.attributedString.string)
		}
		
		// Send cell to calculator
		self.calculatorBrain.evaluateSelectedCalculatorCell(itemIdentifier.calculatorCell)
		
		// Update outputLabel with outputTerm - this also updates the font
		self.labelView.outputLabel.updateText()
		
		// Update accessibility properties for labelView
		self.labelView.accessibilityLabel = "result" + self.labelView.outputLabel.attributedText!.string
		return false
	}
	
	func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
		return false
	}
	
	func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
		switch Calculators.active {
		case .scientific:
			let item: Int = {
				switch originalIndexPath.item {
			case 6:
				return 0
			case 7:
				return 1
			case 8:
				return 2
			case 9:
				return 3
			case 16:
				return 4
			case 17:
				return 5
			case 18:
				return 6
			case 19:
				return 7
			case 26:
				return 8
			case 27:
				return 9
			case 28:
				return 10
			case 29:
				return 11
			case 36:
				return 12
			case 37:
				return 13
			case 38:
				return 14
			case 39:
				return 15
			case 46:
				return 16
			case 47:
				return 17
			case 48:
				return 18
			default:
				return proposedIndexPath.item
			}
			}()
			return IndexPath(item: item, section: 0)
		case .standard:
			let item: Int = {
				switch originalIndexPath.item {
				case 0:
					return 6
				case 1:
					return 7
				case 2:
					return 8
				case 3:
					return 9
				case 4:
					return 16
				case 5:
					return 17
				case 6:
					return 18
				case 7:
					return 19
				case 8:
					return 26
				case 9:
					return 27
				case 10:
					return 28
				case 11:
					return 29
				case 12:
					return 36
				case 13:
					return 37
				case 14:
					return 38
				case 15:
					return 39
				case 16:
					return 46
				case 17:
					return 47
				case 18:
					return 48
				default:
					return proposedIndexPath.item
				}
			}()
			return IndexPath(item: item, section: 0)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, shouldSpringLoadItemAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
		guard Calculators.active == .scientific else { return false }
		
		let item = indexPath.item
		
		if item < 6 {
			return false
		}
		if item > 9 && item < 16 {
			return false
		}
		if item > 19 && item < 26 {
			return false
		}
		if item > 29 && item < 36 {
			return false
		}
		if item > 39 && item < 46 {
			return false
		}
		return true
	}
}
