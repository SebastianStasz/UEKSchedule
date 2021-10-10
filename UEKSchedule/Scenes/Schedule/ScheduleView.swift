//
//  ScheduleView.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import SwiftUI

struct ScheduleView: View {

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = SchduleVM()
    let facultyGroup: ScheduleGroup

    var body: some View {
        Text("Events: \(viewModel.events.count)")
            .navigationTitle(facultyGroup.name)
            .task { await viewModel.checkCalendarAccess() }
            .onAppear { viewModel.facultyGroup = facultyGroup }
            .alert("Calendar access denied", isPresented: $viewModel.noCalendarAccessPopup) {
                Button("OK") { dismiss() }
            }
    }
}


// MARK: - Preview

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(facultyGroup: .sampleFacultyGroup)
    }
}
