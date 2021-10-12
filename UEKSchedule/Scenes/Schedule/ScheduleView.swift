//
//  ScheduleView.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import SwiftUI

struct ScheduleView: View {

    @ObservedObject var viewModel: ScheduleVM
    @State private var isEventListPresented = false

    var body: some View {
        Form {
            Text(viewModel.facultyGroup.name)

            Section {
                Text(String.schedule_foundedEvents(count: viewModel.events.count)).textBodyThin
                Button(.common_showAll, action: presentEventList)
                    .displayIf(viewModel.events.isNotEmpty)
            }

            Section {
                if viewModel.calendarExists {
                    Text(String.schedule_calendarExists).textBodyThin
                    Button(.schedule_updateCalendar, action: updateCalendar)
                } else {
                    Button(.schedule_createCalendar, action: createCalendar)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .buttonStyle(TextButtonStyle())
        .alert(item: $viewModel.navigator.alert) { $0.body }
        .navigation(isActive: $isEventListPresented) {
            EventList(title: viewModel.facultyGroup.name, events: viewModel.events)
        }
    }

    // MARK: - Interactions

    private func updateCalendar() {
        viewModel.input.updateCalendar.send()
    }

    private func createCalendar() {
        viewModel.input.createCalendar.send()
    }

    private func presentEventList() {
        isEventListPresented = true
    }
}


// MARK: - Preview

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(viewModel: .init(facultyGroup: .sampleFacultyGroup))
    }
}
