//
//  Array+Ext.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import Foundation

extension Array {
    var second: Element? {
        guard self.count > 1 else { return nil }
        return self[1]
    }

    var isNotEmpty: Bool {
        !self.isEmpty
    }
}
