//
//  DisplayIf.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import SwiftUI

struct DisplayIf: ViewModifier {

    var condition: Bool

    func body(content: Content) -> some View {
        if condition { content }
    }
}

extension View {
    func displayIf(_ condition: Bool) -> some View {
        self.modifier(DisplayIf(condition: condition))
    }
}
