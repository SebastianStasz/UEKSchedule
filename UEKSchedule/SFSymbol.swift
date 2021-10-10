//
//  SFSymbol.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import Foundation

public enum SFSymbol: String {
    case settings = "gearshape"
}

public extension SFSymbol {
    var name: String { rawValue }
}
