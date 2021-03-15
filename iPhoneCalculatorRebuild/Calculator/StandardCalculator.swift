//
//  StandardCalculator.swift
//  iPhoneCalculatorRebuild
//
//  Created by Alfredo Colon on 5/28/20.
//  Copyright © 2020 Alfredo Colon. All rights reserved.
//

import UIKit

class StandardCalculator {
	
	//MARK: - AttributedStringFormatter
	
	enum AttributedStringFormatter {
		case ClearType(String)
		case Decimal(String)
		case Digit(String)
		case Equal(String)
		case Operator(String)
		case PercentageFunction(String)
		case ToggleNumberSignMinus(String)
		case ToggleNumberSignPlus(String)
		case ToggleNumberSignSolidus(String)
		indirect case ToggleNumberSign(AttributedStringFormatter, AttributedStringFormatter, AttributedStringFormatter)

		//MARK: - Attributes

		var baselineOffset: NSNumber { return 0 }

		var font: UIFont! {
			switch self {
			case .Operator:
				return Fonts.SFProTextRegular(45).font
			default:
				return Fonts.SFProTextRegular(40).font
			}
		}

		var kern: Int {
			switch self {
			default:
				return 0
			}
		}

		func range(length: Int) -> NSRange {
			return NSRange(location: 0, length: length)
		}
		
		//MARK: - FormattedAttributedString
		
		var formattedAttributedString: NSAttributedString {
			switch self {
				
			//MARK: - Cases
				
			case .ClearType(let string):
				return formatString(for: string)
			case .Decimal(let string):
				return formatString(for: string)
			case .Digit(let string):
				return formatString(for: string)
			case .Equal(let string):
				return formatString(for: string)
			case .Operator(let string):
				return formatString(for: string)
			case .PercentageFunction(let string):
				return formatString(for: string)
			case .ToggleNumberSignMinus(let string):
				return formatString(for: string)
			case .ToggleNumberSignPlus(let string):
				return formatString(for: string)
			case .ToggleNumberSignSolidus(let string):
				return formatString(for: string)

			//MARK: - Indirect Cases

			case .ToggleNumberSign(let plusSign, let solidus, let minusSign):
				let mutableAttributedString = NSMutableAttributedString()
				
				mutableAttributedString.append(plusSign.formattedAttributedString)
				mutableAttributedString.append(solidus.formattedAttributedString)
				mutableAttributedString.append(minusSign.formattedAttributedString)
				
				return mutableAttributedString
			}
		}
		
		//MARK: - Format String
		
		func formatString(for string: String) -> NSMutableAttributedString {
			let mutableAttributedString = NSMutableAttributedString(string: string)
			
			let range = self.range(length: string.count)
			
			mutableAttributedString.addAttributes([NSAttributedString.Key.baselineOffset : self.baselineOffset], range: range)
			mutableAttributedString.addAttributes([NSAttributedString.Key.kern : self.kern], range: range)
			mutableAttributedString.addAttributes([NSAttributedString.Key.font : self.font!], range: range)
		
			return mutableAttributedString
		}
	}
	
	// MARK: - Layouts
	
	struct Layouts {
		let actual: UICollectionViewCompositionalLayout!
		static let test: UICollectionViewCompositionalLayout = {
			let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalHeight(1.0))
			   let item = NSCollectionLayoutItem(layoutSize: itemSize)
			   
			   let rowSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))
			   let row = NSCollectionLayoutGroup.horizontal(layoutSize: rowSize, subitem: item, count: 5)
			   
			   let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
			   let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [row])

			   let section = NSCollectionLayoutSection(group: group)

			   let layout = UICollectionViewCompositionalLayout(section: section)

			   return layout
		   }()
		
		init(objectSizes: ObjectSizes) {
			self.actual = {
				let itemInfo = objectSizes.actual.collectionView.objects.item
				let inset = itemInfo.inset
				let itemWidth = itemInfo.width
				let itemHeight = itemInfo.height
				
				let itemsInRow = Int(objectSizes.actual.collectionView.objects.view.itemsInRow)
				
				let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .absolute(itemHeight))
				let item = NSCollectionLayoutItem(layoutSize: itemSize)
				item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
				
				let rowSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(itemHeight))
				let row = NSCollectionLayoutGroup.horizontal(layoutSize: rowSize, subitem: item, count: itemsInRow)
				
				let zeroItemWidth = itemInfo.width * 2.0
				let zeroItemSize = NSCollectionLayoutSize(widthDimension: .absolute(zeroItemWidth), heightDimension: .absolute(itemInfo.height))
				let zeroItem = NSCollectionLayoutItem(layoutSize: zeroItemSize)
				zeroItem.contentInsets = NSDirectionalEdgeInsets(top: itemInfo.inset, leading: itemInfo.inset, bottom: itemInfo.inset, trailing: itemInfo.inset)
				
				let lastRowSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(itemInfo.height))
				
				let lastRow = NSCollectionLayoutGroup.horizontal(layoutSize: lastRowSize, subitems: [
					zeroItem,
					item,
					item
				])
				
				let groupWidth = itemWidth * CGFloat(itemsInRow)
				let groupHeight = itemHeight * 5
				let groupSize = NSCollectionLayoutSize(
					widthDimension: .absolute(groupWidth),
					heightDimension: .absolute(groupHeight)
				)

				let group = NSCollectionLayoutGroup.vertical(
					layoutSize: groupSize,
					subitems: [
						row,
						row,
						row,
						row,
						lastRow
					]
				)

				let section = NSCollectionLayoutSection(group: group)

				let layout = UICollectionViewCompositionalLayout(section: section)

				return layout
			}()
		}
	}
	
	// MARK: - Constraints
	
	struct Constraints {
		
		// MARK: - Models
		
		struct LabelView {
			let height: NSLayoutConstraint
			let top: NSLayoutConstraint
		}
		struct CollectionView {
			let width: NSLayoutConstraint
			let height: NSLayoutConstraint
		}
		struct OutputLabel {
			let leading: NSLayoutConstraint
			let trailing: NSLayoutConstraint
		}
		struct SIUnitLabel {
			let centerX: NSLayoutConstraint
		}
		
		// MARK: - Properties
		
		let labelView: LabelView
		let collectionView: CollectionView
		let outputLabel: OutputLabel
		var siUnitLabel: SIUnitLabel
		
		// MARK: - Methods
		
		func deactivate() {
			NSLayoutConstraint.deactivate([
				self.collectionView.height,
				self.collectionView.width,
				self.labelView.height,
				self.labelView.top,
				self.outputLabel.leading,
				self.outputLabel.trailing,
				self.siUnitLabel.centerX
			])
		}
		
		func activate() {
			NSLayoutConstraint.activate([
				self.collectionView.height,
				self.collectionView.width,
				self.labelView.height,
				self.labelView.top,
				self.outputLabel.leading,
				self.outputLabel.trailing,
				self.siUnitLabel.centerX
			])
		}
		
		init(objectSizes: ObjectSizes, vc: CalculatorViewController) {
			self.labelView = {
				let top = vc.labelView.topAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.topAnchor, constant: 0)
				let heightConstraint = vc.labelView.heightAnchor.constraint(equalToConstant: objectSizes.actual.labelView.object.view.height)
				return LabelView(height: heightConstraint, top: top)
			}()
			
			self.collectionView = {
				let width = objectSizes.actual.collectionView.objects.view.width
				let height = objectSizes.actual.collectionView.objects.view.height
				let widthConstraint = vc.collectionView.widthAnchor.constraint(equalToConstant: width)
				let heightConstraint = vc.collectionView.heightAnchor.constraint(equalToConstant: height)
				return CollectionView(width: widthConstraint, height: heightConstraint)
			}()
			
			self.outputLabel = {
				let outputLabel = vc.labelView!.outputLabel!
				let item = objectSizes.actual.collectionView.objects.item
				
				let testStringSize: CGSize = {
					let standardFont: UIFont! = Fonts.SFProTextRegular(95).font
					let attributedString = NSAttributedString(string: "0", attributes: [.font : standardFont!])
					let size = attributedString.size()
					return size
				}()
				
				let constant = ((item.width - testStringSize.width) / 2)
				let leading = outputLabel.leadingAnchor.constraint(greaterThanOrEqualTo: vc.labelView!.leadingAnchor, constant: constant)
				
				let trailing = outputLabel.trailingAnchor.constraint(equalTo: vc.collectionView!.trailingAnchor, constant: -constant)
				
				return OutputLabel(leading: leading, trailing: trailing)
			}()

			self.siUnitLabel = {
				let siUnitLabel = vc.labelView.siUnitLabel!
				let item = objectSizes.actual.collectionView.objects.item
				let collectionView = vc.collectionView!

				let constant = (item.width / 2)

				let centerX = siUnitLabel.centerXAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: constant)
				return SIUnitLabel(centerX: centerX)
			}()
		}
	}
	
	// MARK: - NumberFormatter
	
	class StandardCalculatorNumberFormatter: NumberFormatter {
		
		//MARK: - Properties

		var decimalMaximum: Double = 999999999
		var decimalMinimum: Double = -999999999
		var decimalDigitMaximum: Int = 9
		
		//MARK: - Init
		
		override init() {
			super.init()
			self.exponentSymbol = "e"
			self.negativeInfinitySymbol = "Error"
			self.negativePrefix = "−"
			self.nilSymbol = "Error"
			self.notANumberSymbol = "Error"
			self.positiveInfinitySymbol = "Error"
		}
		
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
		
		//MARK: - Methods
		
		func updateProperties(for number: NSNumber, integerDigits: Int, fractionDigits: Int) {
			let doubleValue = number.doubleValue
			
			//Floatcheck - Mainly for when the percentage function gets pressed repeatedly
			let useScientificNotationForFloat: Bool = {
				let floatValue = number.floatValue
				let string: String! = String(floatValue.magnitude)
				let substring = string.split(separator: "e")
				if substring.count > 1 {
					let string = substring[1]
					let double: Int! = Int(string)
					self.usesSignificantDigits = true
					let magnitudeLimit: Int = -self.decimalDigitMaximum - integerDigits
					return double < magnitudeLimit
				}
				return false
			}()
			
			//ScientificNotation
			if doubleValue < self.decimalMinimum || doubleValue > self.decimalMaximum || useScientificNotationForFloat {
				self.numberStyle = .scientific
				self.usesGroupingSeparator = false
				self.usesSignificantDigits = true
			}
			
			//Decimal
			else {
				self.maximumIntegerDigits = integerDigits < self.decimalDigitMaximum ? integerDigits : self.decimalDigitMaximum
				
				let availableDigits: Int = self.decimalDigitMaximum
				self.maximumFractionDigits = availableDigits < fractionDigits ? availableDigits : fractionDigits
				self.minimumFractionDigits = availableDigits < fractionDigits ? availableDigits : fractionDigits
				self.numberStyle = .decimal
				self.usesGroupingSeparator = true
				self.usesSignificantDigits = false
			}
		}
	}
	
	// MARK: - Object Sizes
	
	struct ObjectSizes {
		
		// MARK: - Models
		
		struct Objects {
			
			// MARK: - Models
			
			struct CollectionView {
				
				// MARK: - Models
				
				struct CollectionViewObjects {
					
					// MARK: - Models
					
					struct Item {
						let width: CGFloat
						let height: CGFloat
						let inset: CGFloat
					}
					
					struct View {
						let itemsInRow: CGFloat
						let rows: CGFloat
						let width: CGFloat
						let height: CGFloat
					}
					
					// MARK: - Properties
					
					let item: Item
					let view: View
				}
				
				let objects: CollectionViewObjects
			}
			
			struct LabelView {
				
				// MARK: - Models
				
				struct Objects {
					
					// MARK: - Models
					
					struct Label {
						let width: CGFloat = 0
						let height: CGFloat = 0
					}
					struct SIUnitLabel {
						let width: CGFloat = 0
						let height: CGFloat = 0
					}
					struct View {
						let height: CGFloat
						let width: CGFloat
					}

					// MARK: - Properties
					
					let label: Label? = nil
					let siUnitLabel: SIUnitLabel? = nil
					let view: View
				}
				
				// MARK: - Properties
				
				let object: Objects
			}
			
			struct View {
				let width: CGFloat
				let height: CGFloat
			}
			
			// MARK: - Properties
			
			let view: View
			let collectionView: CollectionView
			let labelView: LabelView
		}
		
		// MARK: - Properties
		
		var example: Objects!
		var actual: Objects!
		
		// MARK: Init
		
		init(view: UIView) {
			self.example = self.exampleStandard()
			self.actual = self.actualStandard(view: view)
		}
		
		// MARK: - Example Information
		
		func exampleStandard() -> Objects {
			let view: Objects.View = {
				let width: CGFloat = 828
				let height: CGFloat = 1710

				return Objects.View(width: width, height: height)
			}()

			let collectionView: Objects.CollectionView = {
				let item: Objects.CollectionView.CollectionViewObjects.Item = {
					let width: CGFloat = 198
					let height: CGFloat = 198
					let inset: CGFloat = 14

					return Objects.CollectionView.CollectionViewObjects.Item(width: width, height: height, inset: inset)
				}()
				let view: Objects.CollectionView.CollectionViewObjects.View = {
					let itemsInRow: CGFloat = 4
					let rows: CGFloat = 5
					let width: CGFloat = itemsInRow * item.width
					let height: CGFloat = rows * item.height

					return Objects.CollectionView.CollectionViewObjects.View(itemsInRow: itemsInRow, rows: rows, width: width, height: height)
				}()
				return Objects.CollectionView.init(objects: Objects.CollectionView.CollectionViewObjects(item: item, view: view))
			}()
			
			let labelView: Objects.LabelView = {
				let view = Objects.LabelView.Objects.View(height: 777, width: view.width)
				return Objects.LabelView(object: Objects.LabelView.Objects(view: view))
			}()
			
			return Objects(view: view, collectionView: collectionView, labelView: labelView)
		}
		
		func actualStandard(view: UIView) -> Objects {
			let frame = view.frame
			let safeAreaInsets = view.safeAreaInsets
			let view: Objects.View = {
				var width: CGFloat = frame.width < frame.height ? frame.width : frame.height
				var height: CGFloat = frame.width > frame.height ? frame.width : frame.height
				// Account for safe areas
				// Account for safe areas
				let topInset = CGFloat(safeAreaInsets.top)
				let bottomInset = CGFloat(safeAreaInsets.bottom)
				let leftInset = CGFloat(safeAreaInsets.left)
				let rightInset = CGFloat(safeAreaInsets.right)
				height -= (topInset + bottomInset)
				width -= (leftInset + rightInset)
				return Objects.View(width: width, height: height)
			}()
			
			let collectionView: Objects.CollectionView = {
				let item: Objects.CollectionView.CollectionViewObjects.Item = {
					var itemWidth = view.width / 4
					var itemHeight = itemWidth
					
					let totalHeight = itemHeight * 5
					if totalHeight > view.height {
						let scale = view.height / totalHeight
						itemWidth *= scale
						itemHeight *= scale
					}
					
					let inset: CGFloat = {
						let insetScale = example.collectionView.objects.item.inset / example.collectionView.objects.item.width
						return insetScale * itemWidth
					}()

					return Objects.CollectionView.CollectionViewObjects.Item(width: itemWidth, height: itemHeight, inset: inset)
				}()
				let view: Objects.CollectionView.CollectionViewObjects.View = {
					let itemsInRow = example.collectionView.objects.view.itemsInRow
					let rows = example.collectionView.objects.view.rows
					let width: CGFloat = itemsInRow * item.width
					let height: CGFloat = rows * item.height

					return Objects.CollectionView.CollectionViewObjects.View(itemsInRow: itemsInRow, rows: rows, width: width, height: height)
				}()
				return Objects.CollectionView.init(objects: Objects.CollectionView.CollectionViewObjects(item: item, view: view))
			}()
			
			let labelView: Objects.LabelView = {
				let view: Objects.LabelView.Objects.View = {
					let height = view.height - collectionView.objects.view.height
					let width = view.width
					return Objects.LabelView.Objects.View(height: height, width: width)
				}()
				
				return Objects.LabelView(object: Objects.LabelView.Objects(view: view))
			}()
			
			return Objects(view: view, collectionView: collectionView, labelView: labelView)
		}
	}
	
	//MARK: - Properties
	
	let calculatorCells: [Int : CalculatorCell]
	let numberFormatter: StandardCalculatorNumberFormatter
	var objectSizes: ObjectSizes?
	var layouts: Layouts?
	var constraints: Constraints?
	
	// MARK: - Init
	
	init() {
		self.calculatorCells = [
		   0: CalculatorCell.clear(CalculatorCell.Clear.AllClear),
		   1: CalculatorCell.toggleNumberSign(CalculatorCell.ToggleNumberSign.ToggleNumberSign),
		   2: CalculatorCell.percentageFunction(CalculatorCell.PercentageFunction.PercentageFunction),
		   3: CalculatorCell.operator_(CalculatorCell.Operator.Division),
		   4: CalculatorCell.digit(CalculatorCell.Digit.Seven),
		   5: CalculatorCell.digit(CalculatorCell.Digit.Eight),
		   6: CalculatorCell.digit(CalculatorCell.Digit.Nine),
		   7: CalculatorCell.operator_(CalculatorCell.Operator.Multiplication),
		   8: CalculatorCell.digit(CalculatorCell.Digit.Four),
		   9: CalculatorCell.digit(CalculatorCell.Digit.Five),
		   10: CalculatorCell.digit(CalculatorCell.Digit.Six),
		   11: CalculatorCell.operator_(CalculatorCell.Operator.Subtraction),
		   12: CalculatorCell.digit(CalculatorCell.Digit.One),
		   13: CalculatorCell.digit(CalculatorCell.Digit.Two),
		   14: CalculatorCell.digit(CalculatorCell.Digit.Three),
		   15: CalculatorCell.operator_(CalculatorCell.Operator.Addition),
		   16: CalculatorCell.digit(CalculatorCell.Digit.Zero),
		   17: CalculatorCell.decimal(CalculatorCell.Decimal.Decimal),
		   18: CalculatorCell.equal(CalculatorCell.Equal.Equal)
		]
		self.numberFormatter = StandardCalculatorNumberFormatter()
	}
	
	//MARK: - Methods
	
	func formatTermNumber(term: Term) -> String {
		guard let number: NSNumber = term.numberValue else { return self.numberFormatter.string(for: nil)! }
		
		switch term {
		case .mutableOperand(let mutableOperand):
			let fractionDigits: Int = mutableOperand.fractionArray.count
			let integerDigits: Int = mutableOperand.integerArray.count
			
			self.numberFormatter.updateProperties(for: number, integerDigits: integerDigits, fractionDigits: fractionDigits)
			
			let formattedNumberString: String! = self.numberFormatter.string(for: number)
			return fractionDigits == 0 && mutableOperand.decimal == true ? formattedNumberString + "." : formattedNumberString
		default:
			let numberString: String = number.stringValue
			let numberSubstring: [Substring] = numberString.split(separator: ".")

			let integerDigits: Int = numberSubstring[0].count
			
			let fractionDigits: Int = {
				guard numberSubstring.count > 1 else { return 0 }
				return numberSubstring[1].count
			}()

			self.numberFormatter.updateProperties(for: number, integerDigits: integerDigits, fractionDigits: fractionDigits)
			
			var formattedNumberString: String! = self.numberFormatter.string(for: number)
			
			//Avoid 9.200000000000000
			if formattedNumberString.contains(".") {
				let reversedFormattedNumberString = formattedNumberString.reversed()
				for char in reversedFormattedNumberString {
					if char == "0" {
						formattedNumberString.removeLast()
					}
					else if char == "." {
						formattedNumberString.removeLast()
						return formattedNumberString
					}
					else {
						return formattedNumberString
					}
				}
			}
			
			return formattedNumberString
		}
	}
}


