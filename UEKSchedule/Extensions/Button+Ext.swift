//
//  Button+Ext.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import SwiftUI

extension Button where Label == Image {

    /// Creates a button that generates its label from a system image name.
    /// - Parameters:
    ///   - systemImage: The key of system graphics from the SF Symbols set.
    ///   - action: The action to perform when the user triggers the button.
    init(systemImage: String, action: @autoclosure @escaping () -> Void) {
        self.init(action: action) { Image(systemName: systemImage) }
    }
}
