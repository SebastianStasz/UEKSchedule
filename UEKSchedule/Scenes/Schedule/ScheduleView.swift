//
//  ScheduleView.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import SwiftUI
import SSUtils

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
                if viewModel.calendarExists, let date = viewModel.calendarLastUpdate {
                    Text(.schedule_calendarExists).textBodyThin
                    Text(String.schedule_lastUpdate(date.string(format: .medium, withTime: true))).textBodyThin
                    buttonWithLoadingIndicator(.schedule_updateCalendar, action: updateCalendar)
                    Button(String.schedule_deleteCalendar, action: presentDeleteCalendarAlert)
                } else {
                    buttonWithLoadingIndicator(.schedule_createCalendar, action: createCalendar)
                }
            }
            .displayIf(viewModel.events.isNotEmpty)
            .disabled(viewModel.isLoading || viewModel.isCalendarUpdating)
        }
        .overlay(LoadingIndicator(displayIf: viewModel.isLoading))
        .disabled(viewModel.isLoading)
        .navigationBarTitleDisplayMode(.inline)
        .buttonStyle(TextButtonStyle())
        .alert(item: $viewModel.navigator.alert) { $0.body }
        .navigation(isActive: $isEventListPresented) {
            EventList(title: viewModel.facultyGroup.name, eventGroups: viewModel.eventGroups)
        }
        .alert(String.schedule_deleteCalendar, isPresented: $viewModel.navigator.isDeleteCalendarAlertPresented, actions: {
            Button(String.common_delete, role: .destructive, action: deleteCalendar)
            Button(String.common_cancel, role: .cancel, action: {})
        }, message: { Text(String.schedule_deleteCalendar_message(calendarName: viewModel.calendarName ?? "")) } )
    }

    private func buttonWithLoadingIndicator(_ label: Language, action: @escaping () -> Void) -> some View {
        HStack {
            Button(label.text, action: action)
            Spacer()
            LoadingIndicator(displayIf: viewModel.isCalendarUpdating)
        }
    }

    // MARK: - Interactions

    private func updateCalendar() {
        viewModel.input.updateCalendar.send()
    }

    private func createCalendar() {
        viewModel.input.createCalendar.send()
    }

    private func deleteCalendar() {
        viewModel.input.deleteCalendar.send()
    }

    private func presentEventList() {
        isEventListPresented = true
    }

    private func presentDeleteCalendarAlert() {
        viewModel.input.showDeleteCalendarAlert.send()
    }
}


// MARK: - Preview

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(viewModel: .init(facultyGroup: .sampleFacultyGroup))
            .embedInNavigationView(title: "Informatyka Stosowana")
    }
}
