//
//  ExtendedNavigationView.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import SwiftUI

private struct ExtendedNavigationView: ViewModifier {

    let title: String?
    let displayMode: NavigationBarItem.TitleDisplayMode

    func body(content: Content) -> some View {
        NavigationView {
            if let title = title {
                content
                    .navigationTitle(LocalizedStringKey(title))
                    .navigationBarTitleDisplayMode(displayMode)
            } else {
                content
            }
        }
    }
}

extension View {
    func embedInNavigationView(title: String? = nil, displayMode: NavigationBarItem.TitleDisplayMode = .automatic) -> some View {
        self.modifier(ExtendedNavigationView(title: title, displayMode: displayMode))
    }
}
