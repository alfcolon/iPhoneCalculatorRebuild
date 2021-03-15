//
//  ScientificCalculator.swift
//  iPhoneCalculatorRebuild
//
//  Created by Alfredo Colon on 5/28/20.
//  Copyright © 2020 Alfredo Colon. All rights reserved.
//

import UIKit

class ScientificCalculator {

////	 MARK: - Models
	
	//MARK: - AttributedStringFormatter
	
	enum AttributedStringFormatter {
		case ClearType(String)
		case Constant(String)
		case Decimal(String)
		case Digit(String)
		case Equal(String)
		case Factorial(String)
		case ExponentFunctionBase(String)
		case ExponentFunctionExponent(String)
		case LogFunctionBase(String)
		case LogFunctionText(String)
		case Operator(String)
		case Parenthesis(String)
		case PercentageFunction(String)
		case MemoryRecall(String)
		case ReciprocalDenominator(String)
		case ReciprocalNumerator(String)
		case ReciprocalSolidus(String)
		case RootFunctionCoefficient(String)
		case RootFunctionCoefficientY(String)
		case RootFunctionRadicand(String)
		case RootFunctionRadicandY(String)
		case SIUnit(String)
		case ToggleNumberSignMinus(String)
		case ToggleNumberSignPlus(String)
		case ToggleNumberSignSolidus(String)
		case ToggleSecondSetOfFunctionsText(String)
		case ToggleSecondSetOfFunctionsSuperscript(String)
		case TrigonometricFunctionText(String)
		case TrigonometricFunctionInverseExponent(String)
		indirect case ExponentFunction(AttributedStringFormatter, AttributedStringFormatter?)
		indirect case LogFunction(AttributedStringFormatter, AttributedStringFormatter?)
		indirect case ReciprocalFunction(AttributedStringFormatter, AttributedStringFormatter, AttributedStringFormatter)
		indirect case RootFunction(AttributedStringFormatter, AttributedStringFormatter)
		indirect case ToggleNumberSign(AttributedStringFormatter, AttributedStringFormatter, AttributedStringFormatter)
		indirect case ToggleSecondSetOfFunctions(AttributedStringFormatter, AttributedStringFormatter)
		indirect case TrigonometricFunction(AttributedStringFormatter, AttributedStringFormatter?)
		
		//MARK: - Attributes
		
		var baselineOffset: NSNumber {
			switch self {
			case .ClearType,
				 .Constant,
				 .Decimal,
				 .Digit,
				 .Equal,
				 .Factorial,
				 .ExponentFunctionBase,
				 .LogFunctionText,
				 .Operator,
				 .Parenthesis,
				 .PercentageFunction,
				 .MemoryRecall,
				 .ReciprocalSolidus,
				 .SIUnit,
				 .ToggleNumberSignMinus,
				 .ToggleNumberSignPlus,
				 .ToggleNumberSignSolidus,
				 .ToggleSecondSetOfFunctionsText,
				 .TrigonometricFunctionText:
					return 0
			case .ExponentFunctionExponent,
				 .ToggleSecondSetOfFunctionsSuperscript:
					return 5
			case .LogFunctionBase:
					return -2
			case .ReciprocalDenominator:
					return -1
			case .ReciprocalNumerator:
					return -1
			case .RootFunctionCoefficient:
					return 5
			case .RootFunctionRadicand:
					return 0
			case .RootFunctionRadicandY:
					return 6
			case .TrigonometricFunctionInverseExponent:
					return 5
			default:
				return 0
			}
		}
		
		var font: UIFont! {
			switch self {
			case .Constant,
				 .LogFunctionText,
				 .MemoryRecall,
				 .Parenthesis,
				 .ReciprocalNumerator,
				 .ReciprocalSolidus,
				 .SIUnit,
				 .ToggleSecondSetOfFunctionsText,
				 .TrigonometricFunctionText:
				return Fonts.SFProTextRegular(17).font
			case .ClearType,
				 .Decimal,
				 .Digit,
				 .PercentageFunction,
				 .ToggleNumberSignMinus,
				 .ToggleNumberSignPlus,
				 .ToggleNumberSignSolidus:
				return Fonts.SFProTextRegular(25).font
			case .Equal,
				 .Operator:
				return Fonts.SFProTextRegular(30).font
			case .ExponentFunctionExponent,
				 .LogFunctionBase,
				 .ToggleSecondSetOfFunctionsSuperscript:
				return Fonts.SFProTextRegular(11).font
			case .ReciprocalDenominator:
				return Fonts.SFProTextRegular(14).font
			case .RootFunctionCoefficient(let string):
				return string == "ʸ" ?
				Fonts.SFProTextRegular(20).font
				:
				Fonts.SFProTextRegular(10).font
			case .RootFunctionRadicand,
				 .RootFunctionRadicandY:
				return Fonts.SFProTextRegular(15).font
			case .TrigonometricFunctionInverseExponent:
				return Fonts.SFProTextRegular(10).font
			default:
				return Fonts.SFProTextRegular(17).font
			}
		}
		
		var kern: Int {
			switch self {
			case .RootFunctionCoefficient:
				return 5
			case .RootFunctionCoefficientY:
				return 5
			default:
				return 0
			}
		}
		
		func range(length: Int) -> NSRange {
			return NSRange(location: 0, length: length)
		}
		
		//MARK: - Methods
		
		func formatString(for string: String) -> NSMutableAttributedString {
			let mutableAttributedString = NSMutableAttributedString(string: string)
			
			let range = self.range(length: string.count)
			
			mutableAttributedString.addAttributes([NSAttributedString.Key.baselineOffset : self.baselineOffset], range: range)
			mutableAttributedString.addAttributes([NSAttributedString.Key.kern : self.kern], range: range)
			mutableAttributedString.addAttributes([NSAttributedString.Key.font : self.font!], range: range)

			return mutableAttributedString
		}
		
		var formattedAttributedString: NSAttributedString {
			switch self {
				
			//MARK: - Cases
				
			case .ClearType(let string):
				return formatString(for: string)
			case .Constant(let string):
				return formatString(for: string)
			case .Decimal(let string):
				return formatString(for: string)
			case .Digit(let string):
				return formatString(for: string)
			case .Equal(let string):
				return formatString(for: string)
			case .Factorial(let string):
				return formatString(for: string)
			case .ExponentFunctionBase(let string):
				return formatString(for: string)
			case .ExponentFunctionExponent(let string):
				return formatString(for: string)
			case .LogFunctionBase(let string):
				return formatString(for: string)
			case .LogFunctionText(let string):
				return formatString(for: string)
			case .Operator(let string):
				return formatString(for: string)
			case .Parenthesis(let string):
				return formatString(for: string)
			case .PercentageFunction(let string):
				return formatString(for: string)
			case .MemoryRecall(let string):
				return formatString(for: string)
			case .ReciprocalDenominator(let string):
				return formatString(for: string)
			case .ReciprocalNumerator(let string):
				return formatString(for: string)
			case .ReciprocalSolidus(let string):
				return formatString(for: string)
			case .RootFunctionCoefficient(let string):
				return formatString(for: string)
			case .RootFunctionCoefficientY(let string):
				return formatString(for: string)
			case .RootFunctionRadicand(let string):
				return formatString(for: string)
			case .RootFunctionRadicandY(let string):
				return formatString(for: string)
			case .SIUnit(let string):
				return formatString(for: string)
			case .ToggleNumberSignMinus(let string):
				return formatString(for: string)
			case .ToggleNumberSignPlus(let string):
				return formatString(for: string)
			case .ToggleNumberSignSolidus(let string):
				return formatString(for: string)
			case .ToggleSecondSetOfFunctionsText(let string):
				return formatString(for: string)
			case .ToggleSecondSetOfFunctionsSuperscript(let string):
				return formatString(for: string)
			case .TrigonometricFunctionText(let string):
				return formatString(for: string)
			case .TrigonometricFunctionInverseExponent(let string):
				return formatString(for: string)

			//MARK: - Indirect Cases
				
			case .ExponentFunction(let functionName, let exponent):
				let mutableAttributedString = NSMutableAttributedString()
				mutableAttributedString.append(functionName.formattedAttributedString)
				if let exponent = exponent {
					mutableAttributedString.append(exponent.formattedAttributedString)
				}
				return mutableAttributedString
			case .LogFunction(let logFunctionText, let logFunctionBase):
				let mutableAttributedString = NSMutableAttributedString()
				mutableAttributedString.append(logFunctionText.formattedAttributedString)
				if let base = logFunctionBase {
					mutableAttributedString.append(base.formattedAttributedString)
				}
				return mutableAttributedString
			case .ReciprocalFunction(let numerator, let solidus, let denominator):
				let mutableAttributedString = NSMutableAttributedString()
				mutableAttributedString.append(numerator.formattedAttributedString)
				mutableAttributedString.append(solidus.formattedAttributedString)
				mutableAttributedString.append(denominator.formattedAttributedString)
				return mutableAttributedString
			case .RootFunction(let coefficient, let radicand):
				let mutableAttributedString = NSMutableAttributedString()
				mutableAttributedString.append(coefficient.formattedAttributedString)
				mutableAttributedString.append(radicand.formattedAttributedString)
				return mutableAttributedString
			case .ToggleNumberSign(let plusSign, let solidus, let minusSign):
				let mutableAttributedString = NSMutableAttributedString()
				mutableAttributedString.append(plusSign.formattedAttributedString)
				mutableAttributedString.append(solidus.formattedAttributedString)
				mutableAttributedString.append(minusSign.formattedAttributedString)
				return mutableAttributedString
			case .ToggleSecondSetOfFunctions(let functionText, let superscript):
				let mutableAttributedString = NSMutableAttributedString()
				mutableAttributedString.append(functionText.formattedAttributedString)
				mutableAttributedString.append(superscript.formattedAttributedString)
				return mutableAttributedString
			case .TrigonometricFunction(let functionName, let inverseExponent):
				let mutableAttributedString = NSMutableAttributedString()
				mutableAttributedString.append(functionName.formattedAttributedString)
				if let exponent = inverseExponent {
					mutableAttributedString.append(exponent.formattedAttributedString)
				}
				return mutableAttributedString
			}
		}
	}
	
	// MARK: - Layouts
	
	struct Layouts {
		let actual: UICollectionViewCompositionalLayout!
		static let test: UICollectionViewCompositionalLayout = {
			let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalHeight(1.0))
			   let item = NSCollectionLayoutItem(layoutSize: itemSize)
			   
			   let rowSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))
			   let row = NSCollectionLayoutGroup.horizontal(layoutSize: rowSize, subitem: item, count: 10)
			   
			   let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
			   let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [row])

			   let section = NSCollectionLayoutSection(group: group)

			   let layout = UICollectionViewCompositionalLayout(section: section)

			   return layout
		   }()
		
		init(objectSizes: ObjectSizes) {
			self.actual = {
				let itemInfo = objectSizes.actual.collectionView.objects.item
				let itemWidth = itemInfo.width
				let itemHeight = itemInfo.height
				let inset = itemInfo.inset
				let itemsInRow = Int(objectSizes.actual.collectionView.objects.view.itemsInRow)
				
				let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .absolute(itemHeight))
				let item = NSCollectionLayoutItem(layoutSize: itemSize)
				item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
				
				let rowSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(itemHeight))
				let row = NSCollectionLayoutGroup.horizontal(layoutSize: rowSize, subitem: item, count: itemsInRow)
				
				let zeroItemWidth = itemWidth * 2.0
				let zeroItemSize = NSCollectionLayoutSize(widthDimension: .absolute(zeroItemWidth), heightDimension: .absolute(itemHeight))
				let zeroItem = NSCollectionLayoutItem(layoutSize: zeroItemSize)
				zeroItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
				
				let lastRowSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(itemHeight))
				let lastRow = NSCollectionLayoutGroup.horizontal(layoutSize: lastRowSize, subitems: [
					item,
					item,
					item,
					item,
					item,
					item,
					zeroItem,
					item,
					item
				])
				
				let groupWidth = itemWidth * 10
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
				let viewSize = objectSizes.actual.view
				let collectionViewSize = objectSizes.actual.collectionView.objects.view
				let testStringSize: CGSize = {
					let scientificFont: UIFont! = Fonts.SFProTextRegular(50).font
					let attributedString = NSAttributedString(string: "0", attributes: [.font : scientificFont!])
					let size = attributedString.size()
					return size
				}()
				
				let remainingHeightSpace = viewSize.height - collectionViewSize.height - testStringSize.height
				let topConstant = remainingHeightSpace / 2
				let top = vc.labelView.topAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.topAnchor, constant: topConstant)
//				let top = vc.labelView.topAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.topAnchor, constant: 0)
				
				let heightConstant = testStringSize.height
				let height = vc.labelView.heightAnchor.constraint(equalToConstant: heightConstant)
//				let height = vc.labelView.heightAnchor.constraint(equalToConstant: objectSizes.actual.labelView.object.view.height)
				
				return LabelView(height: height, top: top)
			}()
			
			self.collectionView = {
				let width = objectSizes.actual.collectionView.objects.view.width
				let height = objectSizes.actual.collectionView.objects.view.height
				let widthConstraint = vc.collectionView.widthAnchor.constraint(equalToConstant: width)
				let heightConstraint = vc.collectionView.heightAnchor.constraint(equalToConstant: height)
				return CollectionView(width: widthConstraint, height: heightConstraint)
			}()
			
			self.outputLabel = {
				let outputLabel = vc.labelView.outputLabel!
				let item = objectSizes.actual.collectionView.objects.item
				let labelView = vc.labelView!
				let testStringSize: CGSize = {
					let scientificFont: UIFont! = Fonts.SFProTextRegular(50).font
					let attributedString = NSAttributedString(string: "0", attributes: [.font : scientificFont!])
					let size = attributedString.size()
					return size
				}()
				
				let leadingConstant = item.width * 3
				let leading = outputLabel.leadingAnchor.constraint(greaterThanOrEqualTo: labelView.leadingAnchor, constant: leadingConstant)

				let trailingConstant = ((item.width - testStringSize.width) / 2) * -1
				let trailing = outputLabel.trailingAnchor.constraint(equalTo: vc.collectionView!.trailingAnchor, constant: trailingConstant)
				
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
	
	class ScientificCalculatorNumberFormatter: NumberFormatter {
	 
		 //MARK: - Properties

		 var decimalMaximum: Double = 9999999999999978
		 var decimalMinimum: Double = -9999999999999978
		 var decimalDigitMaximum: Int = 16
		 
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
	
	// MARK: - ObjectSizes
	
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
			self.example = self.exampleScientific()
			self.actual = self.actualScientific(view: view)
		}
		
		// MARK: - Example Information
		
		func exampleScientific() -> Objects {
			let view: Objects.View = {
				let width: CGFloat = 1792
				let height: CGFloat = 807

				return Objects.View(width: width, height: height)
			}()

			let collectionView: Objects.CollectionView = {
				let item: Objects.CollectionView.CollectionViewObjects.Item = {
					let width: CGFloat = 142
					let height: CGFloat = 117
					let inset: CGFloat = 10

					return Objects.CollectionView.CollectionViewObjects.Item(width: width, height: height, inset: inset)
				}()
				let view: Objects.CollectionView.CollectionViewObjects.View = {
					let itemsInRow: CGFloat = 10
					let rows: CGFloat = 5
					let width: CGFloat = itemsInRow * item.width
					let height: CGFloat = rows * item.height

					return Objects.CollectionView.CollectionViewObjects.View(itemsInRow: itemsInRow, rows: rows, width: width, height: height)
				}()
				return Objects.CollectionView.init(objects: Objects.CollectionView.CollectionViewObjects(item: item, view: view))
			}()
			
			let labelView: Objects.LabelView = {
				let view = Objects.LabelView.Objects.View(height: 130, width: view.width)
				return Objects.LabelView(object: Objects.LabelView.Objects(view: view))
			}()
			
			return Objects(view: view, collectionView: collectionView, labelView: labelView)
		}
		
		// Scaling twice!
		func actualScientific(view: UIView) -> Objects {
			let frame = view.frame
			let safeAreaInsets = view.safeAreaInsets
			let view: Objects.View = {
				var width: CGFloat = frame.width > frame.height ? frame.width : frame.height
				var height: CGFloat = frame.width < frame.height ? frame.width : frame.height
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
					var itemWidth = view.width / 10
					var itemHeight = (117 / 142) * itemWidth
					
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
	let numberFormatter: ScientificCalculatorNumberFormatter
	var objectSizes: ObjectSizes?
	var layouts: Layouts?
	var constraints: Constraints?
	
	// MARK: - Init
	
	init() {
		self.calculatorCells =  {
			return [
			   0: CalculatorCell.parentheses(CalculatorCell.Parentheses.OpeningParenthesis),
			   1: CalculatorCell.parentheses(CalculatorCell.Parentheses.ClosingParenthesis),
			   2: CalculatorCell.memoryRecall(CalculatorCell.MemoryRecall.MemoryClear),
			   3: CalculatorCell.memoryRecall(CalculatorCell.MemoryRecall.MemoryPlus),
			   4: CalculatorCell.memoryRecall(CalculatorCell.MemoryRecall.MemoryMinus),
			   5: CalculatorCell.memoryRecall(CalculatorCell.MemoryRecall.MemoryRecall),
			   6: CalculatorCell.clear(CalculatorCell.Clear.AllClear),
			   7: CalculatorCell.toggleNumberSign(CalculatorCell.ToggleNumberSign.ToggleNumberSign),
			   8: CalculatorCell.percentageFunction(CalculatorCell.PercentageFunction.PercentageFunction),
			   9: CalculatorCell.operator_(CalculatorCell.Operator.Division),
			   10: CalculatorCell.toggleSecondSetOfFunctions(CalculatorCell.ToggleSecondSetOfFunctions.ToggleSecondSetOfFunctions),
			   11: CalculatorCell.exponentFunction(CalculatorCell.ExponentFunction.BaseXPowerTwo),
			   12: CalculatorCell.exponentFunction(CalculatorCell.ExponentFunction.BaseXPowerThree),
			   13: CalculatorCell.exponentFunction(CalculatorCell.ExponentFunction.BaseXPowerY),
			   14: CalculatorCell.exponentFunction(CalculatorCell.ExponentFunction.BaseEulersNumberPowerX),
			   15: CalculatorCell.exponentFunction(CalculatorCell.ExponentFunction.BaseTenPowerX),
			   16: CalculatorCell.digit(CalculatorCell.Digit.Seven),
			   17: CalculatorCell.digit(CalculatorCell.Digit.Eight),
			   18: CalculatorCell.digit(CalculatorCell.Digit.Nine),
			   19: CalculatorCell.operator_(CalculatorCell.Operator.Multiplication),
			   20: CalculatorCell.reciprocal(CalculatorCell.Reciprocal.Reciprocal),
			   21: CalculatorCell.rootFunction(CalculatorCell.RootFunction.CoefficientTwoRadicandX),
			   22: CalculatorCell.rootFunction(CalculatorCell.RootFunction.CoefficientThreeRadicandX),
			   23: CalculatorCell.rootFunction(CalculatorCell.RootFunction.CoefficientYRadicandX),
			   24: CalculatorCell.logFunction(CalculatorCell.LogFunction.NaturalLog),
			   25: CalculatorCell.logFunction(CalculatorCell.LogFunction.LogBaseTen),
			   26: CalculatorCell.digit(CalculatorCell.Digit.Four),
			   27: CalculatorCell.digit(CalculatorCell.Digit.Five),
			   28: CalculatorCell.digit(CalculatorCell.Digit.Six),
			   29: CalculatorCell.operator_(CalculatorCell.Operator.Subtraction),
			   30: CalculatorCell.factorial(CalculatorCell.Factorial.Factorial),
			   31: CalculatorCell.trigonometricRightAngleFunction(CalculatorCell.TrigonometricFunctions.RightAngle.Sine),
			   32: CalculatorCell.trigonometricRightAngleFunction(CalculatorCell.TrigonometricFunctions.RightAngle.Cosine),
			   33: CalculatorCell.trigonometricRightAngleFunction(CalculatorCell.TrigonometricFunctions.RightAngle.Tangent),
			   34: CalculatorCell.constant(CalculatorCell.Constant.EulersNumber),
			   35: CalculatorCell.exponentFunction(CalculatorCell.ExponentFunction.EnterExponent),
			   36: CalculatorCell.digit(CalculatorCell.Digit.One),
			   37: CalculatorCell.digit(CalculatorCell.Digit.Two),
			   38: CalculatorCell.digit(CalculatorCell.Digit.Three),
			   39: CalculatorCell.operator_(CalculatorCell.Operator.Addition),
			   40: CalculatorCell.siUnit(CalculatorCell.SIUnit.Radians),
			   41: CalculatorCell.trigonometricHyperbolicFunction(CalculatorCell.TrigonometricFunctions.Hyperbolic.Sine),
			   42: CalculatorCell.trigonometricHyperbolicFunction(CalculatorCell.TrigonometricFunctions.Hyperbolic.Cosine),
			   43: CalculatorCell.trigonometricHyperbolicFunction(CalculatorCell.TrigonometricFunctions.Hyperbolic.Tangent),
			   44: CalculatorCell.constant(CalculatorCell.Constant.Pi),
			   45: CalculatorCell.constant(CalculatorCell.Constant.RandomNumber),
			   46: CalculatorCell.digit(CalculatorCell.Digit.Zero),
			   47: CalculatorCell.decimal(CalculatorCell.Decimal.Decimal),
			   48: CalculatorCell.equal(CalculatorCell.Equal.Equal)
			   ]
		}()
		self.numberFormatter = ScientificCalculatorNumberFormatter()
	
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

