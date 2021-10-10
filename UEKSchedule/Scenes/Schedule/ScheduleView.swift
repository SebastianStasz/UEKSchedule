//
//  ScheduleView.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import SwiftUI

struct ScheduleView: View {

    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ScheduleVM

    var body: some View {
        VStack {
            Text(viewModel.facultyGroup.name)

            Spacer()

            Text("Founded: \(viewModel.events.count) events")
            NavigationLink("Show all", destination: EventList(title: viewModel.facultyGroup.name, events: viewModel.events))
                .displayIf(viewModel.events.isNotEmpty)

            Spacer()

            if viewModel.calendarExists {
                Button("Update calendar") { viewModel.updateCalendar() }
                Text("Calendar for this schedule already exists")
            } else {
                Button("Create calendar") { viewModel.createCalendar() }
            }

            Spacer()
        }
        .task { await viewModel.checkCalendarAccess() }
        .alert("Calendar access denied", isPresented: $viewModel.noCalendarAccessPopup) {
            Button("OK") { dismiss() }
        }
    }
}


// MARK: - Preview

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(viewModel: .init(facultyGroup: .sampleFacultyGroup))
    }
}
