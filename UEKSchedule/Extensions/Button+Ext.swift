//
//  Button+Ext.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import SwiftUI

extension Button where Label == Text {

    /// Creates a button that generates its label from a localized string.
    /// - Parameters:
    ///   - titleKey: The key for the button’s localized title, that describes the purpose of the button’s action.
    ///   - action: The action to perform when the user triggers the button.
    init(_ titleKey: String, action: @escaping () -> Void) {
        self.init(action: action) { Text(titleKey) }
    }
}

extension Button where Label == Image {

    /// Creates a button that generates its label from a system image name.
    /// - Parameters:
    ///   - systemImage: The key of system graphics from the SF Symbols set.
    ///   - action: The action to perform when the user triggers the button.
    init(systemImage: String, action: @autoclosure @escaping () -> Void) {
        self.init(action: action) { Image(systemName: systemImage) }
    }
}
