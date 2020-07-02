//
//  PersistStartingValues.swift
//  iPhoneCalculatorRebuild
//
//  Created by Alfredo Colon on 7/1/20.
//  Copyright © 2020 Alfredo Colon. All rights reserved.
//

import Foundation

protocol PersistStartingValues {
    var persistentFileURL: URL? { get }
    var startingValues: StartingValues? { set get }
    func loadFromPersistentStore()
    func saveToPersistentStore()
}
