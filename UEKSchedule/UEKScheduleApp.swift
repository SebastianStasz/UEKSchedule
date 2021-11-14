//
//  UEKScheduleApp.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 06/10/2021.
//

import SwiftUI
import SSUtils
import UEKScheduleCoreData

@main
struct UEKScheduleApp: App {

    @Environment(\.scenePhase) var scenePhase
    @State private var isAboutPresented = false

    var body: some Scene {
        WindowGroup {
            FacultiesView()
                .navigation(isActive: $isAboutPresented, destination: AboutView.init)
                .toolbar { toolbarContent }
                .embedInNavigationView(title: "Faculties")
                .onChange(of: scenePhase) { phase in
                    if phase == .background {
                        PersistenceController.shared.save()
                    }
                }
                .environment(\.managedObjectContext, PersistenceController.shared.context)
        }
    }

    private var toolbarContent: some ToolbarContent {
        Toolbar.trailing(systemImage: SFSymbol.about.name) { isAboutPresented = true }
    }
}
