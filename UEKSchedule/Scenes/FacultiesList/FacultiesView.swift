//
//  FacultiesView.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import SwiftUI

struct FacultiesView: View {

    @StateObject private var viewModel = FacultiesVM()

    var body: some View {
        List {
            ForEach(viewModel.faculties) {
                NavigationLink($0.name, destination: FacultyGroupsView(faculty: $0))
            }
        }
        .overlay(LoadingIndicator(displayIf: viewModel.isLoading))
        .embedInNavigationView(title: "Faculties")
        .searchable(text: $viewModel.search)
        .refreshable { await viewModel.loadFaculties() }
        .task { await viewModel.loadFaculties() }
    }
}


// MARK: - Preview

struct FacultiesView_Previews: PreviewProvider {
    static var previews: some View {
        FacultiesView()
    }
}
