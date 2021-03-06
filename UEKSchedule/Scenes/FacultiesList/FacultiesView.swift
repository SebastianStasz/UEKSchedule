//
//  FacultiesView.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import SwiftUI
import SSUtils

struct FacultiesView: View {

    @StateObject private var viewModel = FacultiesVM()

    var body: some View {
        List {
            ObservedFacultiesView(observedFaculties: viewModel.observedFaculties)
            Section(header: Text(.common_all)) {
                ForEach(viewModel.faculties) {
                    NavigationLink($0.name, destination: FacultyGroupsView(faculty: $0))
                }
            }
        }
        .overlay(LoadingIndicator(displayIf: viewModel.isLoading))
        .overlay(emptyListDisclaimer)
        .disabled(viewModel.isLoading)
        .searchable(text: $viewModel.search)
        .refreshable { viewModel.refreshFaculties.send() }
        .task { viewModel.loadFaculties.send() }
    }

    private var emptyListDisclaimer: some View {
        Group {
            if viewModel.search.isEmpty {
                Text(.faculties_empty)
            } else {
                Text(.faculties_search_empty)
            }
        }
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
