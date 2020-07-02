//
//  OutputLabelMenuController.swift
//  iPhoneCalculatorRebuild
//
//  Created by Alfredo Colon on 7/1/20.
//  Copyright © 2020 Alfredo Colon. All rights reserved.
//

import UIKit

protocol OutputLabelMenuController {
    func copyText()
    func pasteText()
    func setupLongPressGesture()
    func showTextEditingMenu(_ gesture: UILongPressGestureRecognizer)
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
}
