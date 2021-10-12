//
//  UEKScheduleApp.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 06/10/2021.
//

import SwiftUI

@main
struct UEKScheduleApp: App {

    @State private var isAboutPresented = false

    var body: some Scene {
        WindowGroup {
            FacultiesView()
                .navigation(isActive: $isAboutPresented, destination: AboutView.init)
                .toolbar { toolbarContent }
                .embedInNavigationView(title: "Faculties")
        }
    }

    private var toolbarContent: some ToolbarContent {
        Toolbar.trailing(systemImage: .about) { isAboutPresented = true }
    }
}
