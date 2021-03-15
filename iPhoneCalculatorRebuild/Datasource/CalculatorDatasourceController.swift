//
//  CalculatorDatasourceController.swift
//  iPhoneCalculatorRebuild
//
//  Created by Alfredo Colon on 3/14/21.
//  Copyright © 2021 Alfredo Colon. All rights reserved.
//

import UIKit

class CalculatorDatasourceController {
	
	// MARK: - Models
	
	typealias ItemNumber = Int
	
	// MARK: - Properties
	
	var itemProviders: [Int: CalculatorCollectionViewCellModel]
	var datasource: UICollectionViewDiffableDataSource<ItemNumber, CalculatorCollectionViewCellModel>!
	var snapshotSC: NSDiffableDataSourceSnapshot<ItemNumber, CalculatorCollectionViewCellModel>!
	var snapshotST: NSDiffableDataSourceSnapshot<ItemNumber, CalculatorCollectionViewCellModel>!
	
	// MARK: - Init
	
	init() {
		self.itemProviders = [:]

		for (index, cell) in Calculators.scientific.calculatorCells {
			self.itemProviders[index] = CalculatorCollectionViewCellModel(cell)
		}
		
		self.snapshotSC = {
			var snapShot = NSDiffableDataSourceSnapshot<ItemNumber, CalculatorCollectionViewCellModel>()
			
			snapShot.appendSections([0])
			
			var snapShotItems: [CalculatorCollectionViewCellModel] = []
			for n in 0..<49 {
				snapShotItems.append(self.itemProviders[n]!)
			}
			
			snapShot.appendItems(snapShotItems)
			
			return snapShot
		}()
		
		self.snapshotST = {
			var snapShot = NSDiffableDataSourceSnapshot<ItemNumber, CalculatorCollectionViewCellModel>()
			
			snapShot.appendSections([0])
			
			let snapShotItems: [CalculatorCollectionViewCellModel] = [
				self.itemProviders[6]!,
				self.itemProviders[7]!,
				self.itemProviders[8]!,
				self.itemProviders[9]!,
				self.itemProviders[16]!,
				self.itemProviders[17]!,
				self.itemProviders[18]!,
				self.itemProviders[19]!,
				self.itemProviders[26]!,
				self.itemProviders[27]!,
				self.itemProviders[28]!,
				self.itemProviders[29]!,
				self.itemProviders[36]!,
				self.itemProviders[37]!,
				self.itemProviders[38]!,
				self.itemProviders[39]!,
				self.itemProviders[46]!,
				self.itemProviders[47]!,
				self.itemProviders[48]!
			]

			snapShot.appendItems(snapShotItems)
			
			return snapShot
		}()
	}
	
	func setupDatasource(vc: CalculatorViewController) {
		self.datasource = UICollectionViewDiffableDataSource<ItemNumber, CalculatorCollectionViewCellModel>(collectionView: vc.collectionView!, cellProvider: { (collectionView, indexPath, calcCellItemProvider) -> UICollectionViewCell? in
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CalculatorCollectionViewCell
			
			cell.viewModel = calcCellItemProvider
			cell.viewModel.delegate = cell
			cell.updateProperties()
//			if cell.itemProvider.cellIsSelected {
//				cell.updateAppearenceForSelectedCell()
//			}
			// update zero cell
			let zeroItemWidth: CGFloat = {
				switch Calculators.active {
				case .scientific:
					let width: CGFloat = Calculators.scientific.objectSizes!.actual.collectionView.objects.item.width
					return width
				case .standard:
					let width: CGFloat = Calculators.standard.objectSizes!.actual.collectionView.objects.item.width
					return width
				}
			}()
			cell.updateCenterX(itemWidth: zeroItemWidth)

			return cell
		})
		
		vc.collectionView.dataSource = self.datasource
	}
	
	func toggleDatasources() {
		if Calculators.active == .scientific {
			self.datasource.apply(self.snapshotSC)
		}
		else {
			self.datasource.apply(self.snapshotST)
		}
	}
	
	func setinitialDatasourceSnapshot() {
		if Calculators.active == .scientific {
			self.datasource.apply(self.snapshotSC)
		}
		else {

			self.datasource.apply(self.snapshotST)
		}
	}

	func updateClearCellIfNeeded(for calculatorCell: CalculatorCell) {
		let clear = self.itemProviders[6]!
		
		if clear.calculatorCell.attributedString.string == "AC" {
			guard calculatorCell.attributedString.string != "AC" else { return }
			clear.calculatorCell = clear.calculatorCell.toggledValue!
			clear.delegate?.updateProperties()
		}
		
		else if clear.calculatorCell.attributedString.string == "C" {
			guard calculatorCell.attributedString.string == "C" else { return }
			clear.calculatorCell = clear.calculatorCell.toggledValue!
			clear.delegate?.updateProperties()
		}
	}
	
	func updateClearCellIfNeeded1(for calculatorCell: CalculatorCell) {
		guard let clearCellItemProvider = self.itemProviders[6] else { return }
		guard let clearViewCell = clearCellItemProvider.delegate else { return }
		let clearCellType: CalculatorCell.Clear? = {
			let clearCell = clearCellItemProvider.calculatorCell
			switch clearCell {
			case .clear(let type):
				return type
			default:
				return nil
			}
		}()
			
		switch calculatorCell {
		case .decimal, .digit, .constant:
			guard clearCellType == .AllClear else { return }
			clearCellItemProvider.calculatorCell = clearCellItemProvider.calculatorCell.toggledValue!
			clearViewCell.updateProperties()
		case .clear(let selectedType):
			guard selectedType == .ClearEntry && clearCellType == .ClearEntry else { return }
			clearCellItemProvider.calculatorCell = clearCellItemProvider.calculatorCell.toggledValue!
			clearViewCell.updateProperties()
		default:
			break
		}
	}
	
	func deselectIfNeeded(for calculatorCell: CalculatorCell) {
		let operators = [9, 19, 29, 39]
		let functionsWithTwoInputs = [13, 23, 35]
		let togglablefunctionsWithTwoInputs = [14, 24]
		
		if calculatorCell.togglesSecondSecondSetOfFunctions {
			for item in togglablefunctionsWithTwoInputs {
				let itemIdentifier = self.itemProviders[item]!
				itemIdentifier.cellIsSelected = false
				itemIdentifier.delegate?.updateProperties()
			}
		}
		else {
			let items = operators + functionsWithTwoInputs + togglablefunctionsWithTwoInputs
			
			for item in items {
				let itemIdentifier = self.itemProviders[item]!
				itemIdentifier.cellIsSelected = false
				itemIdentifier.delegate?.updateProperties()
			}
		}
	}
	
	func selectCell(for itemIdentifier: CalculatorCollectionViewCellModel) {
		if itemIdentifier.calculatorCell.togglesSecondSecondSetOfFunctions {
			let togglablefunctionsWithTwoInputs = [14, 15, 24, 25, 31, 32, 33, 41, 42, 43]
			
			for item in togglablefunctionsWithTwoInputs {
				let itemIdentifier = self.itemProviders[item]!
				itemIdentifier.calculatorCell = itemIdentifier.calculatorCell.toggledValue!
				itemIdentifier.delegate?.updateProperties()
			}
			itemIdentifier.cellIsSelected.toggle()
			itemIdentifier.delegate?.updateProperties()
		}
		else {
			itemIdentifier.cellIsSelected = true
			itemIdentifier.delegate?.updateProperties()
		}
		
	}
	
	func toggleSIUnit() {
		let siUnit = self.itemProviders[40]!
		siUnit.calculatorCell = siUnit.calculatorCell.toggledValue!
		self.toggleDatasources()
	}
	
	func updateForSelectedFunctionWithTwoInputs(selectedItem: Int) {
		let functionsWithTwoInputs: [Int] = [13, 14, 23, 24]
		
		for itemNumber in functionsWithTwoInputs {
			if selectedItem != itemNumber {
				self.itemProviders[itemNumber]!.cellIsSelected = false
			}
		}
		self.itemProviders[selectedItem]!.cellIsSelected = true
		self.toggleDatasources()
	}
	
	func updateForSelectedOperator(selectedItem: Int) {
		let operators: [Int] = [9, 19, 29, 39]
		
		
		for itemNumber in operators {
			if selectedItem != itemNumber {
				self.itemProviders[itemNumber]!.cellIsSelected = false
			}
		}
		self.itemProviders[selectedItem]!.cellIsSelected = true
		self.toggleDatasources()
	}
	
	func reselectOperator(_operator: CalculatorCell.Operator) {
		switch _operator {
		case .Addition:
			self.itemProviders[39]?.delegate?.updateAppearenceForSelectedCell()
		case .Division:
			self.itemProviders[9]?.delegate?.updateAppearenceForSelectedCell()
		case .Multiplication:
			self.itemProviders[19]?.delegate?.updateAppearenceForSelectedCell()
		case .Subtraction:
			self.itemProviders[29]?.delegate?.updateAppearenceForSelectedCell()
		}
	}
}

