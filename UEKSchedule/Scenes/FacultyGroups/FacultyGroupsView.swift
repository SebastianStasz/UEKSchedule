//
//  FacultyGroupsView.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import SwiftUI

struct FacultyGroupsView: View {

    @StateObject var viewModel = FacultyGroupsVM()
    private let faculty: ScheduleGroup

    init(faculty: ScheduleGroup) {
        self.faculty = faculty
    }

    var body: some View {
        List {
            ForEach(viewModel.facultyGroups) { facultyGroup in
                NavigationLink(facultyGroup.name) {}
                .onNavigation { viewModel.scheduleVM = .init(facultyGroup: facultyGroup) }
            }
            .displayIf(!viewModel.isLoading)
        }
        .navigationTitle(faculty.name)
        .navigation(item: $viewModel.scheduleVM) { ScheduleView(viewModel: $0) }
        .overlay(LoadingIndicator(displayIf: viewModel.isLoading))
        .searchable(text: $viewModel.search)
        .onAppear { viewModel.faculty = faculty }
    }
}


// MARK: - Preview

struct FacultyGroupsView_Previews: PreviewProvider {
    static var previews: some View {
        FacultyGroupsView(faculty: .sampleFaculty)
    }
}
