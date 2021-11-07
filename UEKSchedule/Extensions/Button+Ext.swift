//
//  Button+Ext.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 07/11/2021.
//

import SwiftUI

extension Button where Label == Text {

    /// Creates a button that generates its label from a localized string.
    /// - Parameters:
    ///   - titleKey: The key for the button’s localized title, that describes the purpose of the button’s action.
    ///   - action: The action to perform when the user triggers the button.
    init(_ titleKey: Language, action: @escaping () -> Void) {
        self.init(action: action) { Text(titleKey.text) }
    }
}
