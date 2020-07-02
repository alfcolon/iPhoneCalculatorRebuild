//
//  MenuController.swift
//  iPhoneCalculatorRebuild
//
//  Created by Alfredo Colon on 7/1/20.
//  Copyright © 2020 Alfredo Colon. All rights reserved.
//

import UIKit

class MenuController: UIMenuController {
    
    //MARK: - Properties
    
    var copiedDouble: Double?
    let pasteBoard: UIPasteboard
    
    //MARK: - Init
    
    override init() {
        self.pasteBoard = UIPasteboard()
        
        super.init()
    }
}
