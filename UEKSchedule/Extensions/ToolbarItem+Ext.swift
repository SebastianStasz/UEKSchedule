//
//  ToolbarItem+Ext.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import SwiftUI

struct Toolbar {}

extension Toolbar {
    static func trailing(systemImage: SFSymbol, action: @escaping () -> Void) -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(systemImage: systemImage.name, action: action())
        }
    }
}
