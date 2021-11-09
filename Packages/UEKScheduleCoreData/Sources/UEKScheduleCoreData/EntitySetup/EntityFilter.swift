//
//  EntityFilter.swift
//  UEKScheduleCoreData
//
//  Created by Sebastian Staszczyk on 09/11/2021.
//

import Foundation

public protocol EntityFilter {
    var nsPredicate: NSPredicate? { get }
}
