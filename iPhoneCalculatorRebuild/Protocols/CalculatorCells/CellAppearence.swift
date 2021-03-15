//
//  CellAppearence.swift
//  iPhoneCalculatorRebuild
//
//  Created by Alfredo Colon on 3/14/21.
//  Copyright © 2021 Alfredo Colon. All rights reserved.
//

import UIKit

protocol CellAppearence {
	var appearenceChangesWhenSelected: Bool { get }
	var backgroundColor: UIColor { get }
	var highlightColor: UIColor { get }
	var selectedBackgroundColor: UIColor? { get }
	var selectedTextColor: UIColor? { get }
	var textColor: UIColor { get }
}
