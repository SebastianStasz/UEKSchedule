//
//  FacultiesView.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import SwiftUI

struct FacultiesView: View {

    @StateObject private var viewModel = FacultiesVM()
    @State private var areSettingsPresented = false

    var body: some View {
        List {
            ForEach(viewModel.faculties) {
                NavigationLink($0.name, destination: FacultyGroupsView(faculty: $0))
            }
        }
        .overlay(LoadingIndicator(displayIf: viewModel.isLoading))
        .overlay(emptyListDisclaimer)
        .navigation(isActive: $areSettingsPresented, destination: SettingsView.init)
        .toolbar { toolbarContent }
        .embedInNavigationView(title: "Faculties")
        .searchable(text: $viewModel.search)
        .refreshable { viewModel.loadFaculties.send() }
        .task { viewModel.loadFaculties.send() }
    }

    private var toolbarContent: some ToolbarContent {
        Toolbar.trailing(systemImage: .settings) { areSettingsPresented = true }
    }

    private var emptyListDisclaimer: some View {
        Text("Could not load faculties. Please try again later.")
            .padding(.horizontal, 20)
            .displayIf(viewModel.faculties.isEmpty && !viewModel.isLoading)
    }
}


// MARK: - Preview

struct FacultiesView_Previews: PreviewProvider {
    static var previews: some View {
        FacultiesView()
    }
}
