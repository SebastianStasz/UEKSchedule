//
//  TextButtonStyle.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 12/10/2021.
//

import SwiftUI

struct TextButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body)
            .foregroundColor(.blue)
            .opacity(configuration.isPressed ? 0.4 : 1)
    }
}
