//
//  ScheduleVM.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import Combine
import Foundation

final class ScheduleVM: ObservableObject {

    private let loadEvents = PassthroughSubject<ScheduleGroup, Never>()
    private let calendarService: CalendarService
    private let service = ScheduleService()
    let facultyGroup: ScheduleGroup

    @Published private(set) var calendarExists = false
    @Published private(set) var events: [Event] = []
    @Published var noCalendarAccessPopup = false

    init(facultyGroup: ScheduleGroup) {
        self.facultyGroup = facultyGroup
        self.calendarService = .init(facultyGroup: facultyGroup)

        calendarService.$calendar
            .map { $0 != nil }
            .assign(to: &$calendarExists)

        loadEvents
            .compactMap { [weak self] in
                self?.service.getEvents(for: $0)
            }
            .switchToLatest()
            .assign(to: &$events)
    }

    func createCalendar() {
        calendarService.createCalendar(with: events)
    }

    func updateCalendar() {
        calendarService.updateCalendar(with: events)
    }

    func checkCalendarAccess() async {
        guard await calendarService.checkCalendarAccess() else {
            noCalendarAccessPopup = true
            return
        }
        loadEvents.send(facultyGroup)
    }
}
