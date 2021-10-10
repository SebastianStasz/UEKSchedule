//
//  CalendarService.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import EventKit
import Foundation

final class CalendarService: ObservableObject {
    private let eventStore = EKEventStore()
    private let facultyGroup: ScheduleGroup

    @Published private(set) var calendar: EKCalendar?
    @Published private(set) var calendars: [EKCalendar] = []

    init(facultyGroup: ScheduleGroup) {
        self.facultyGroup = facultyGroup

        $calendars
            .map { [weak self] _ -> EKCalendar? in
                let calendarId = UserDefaults.standard.string(forKey: facultyGroup.url)
                return self?.eventStore.calendars(for: .event).first { $0.calendarIdentifier == calendarId }
            }
            .assign(to: &$calendar)
    }
    
    func checkCalendarAccess() async -> Bool {
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            loadCalendars()
            return true
        case .notDetermined:
            return await requestAccessToCalendar()
        default:
            return false
        }
    }

    private func requestAccessToCalendar() async -> Bool {
        _ = try? await eventStore.requestAccess(to: .event)
        return await checkCalendarAccess()
    }

    func createCalendar() {
        guard let source = calendarSource else {
            print("Failed to get calendar source")
            return
        }
        let calendar = EKCalendar(for: .event, eventStore: eventStore)
        calendar.title = facultyGroup.name
        calendar.source = source

        do {
            try eventStore.saveCalendar(calendar, commit: true)
            UserDefaults.standard.set(calendar.calendarIdentifier, forKey: facultyGroup.url)
            loadCalendars()
        } catch {
            print("Failed to create calendar")
        }
    }

    private var calendarSource: EKSource? {
        let basic = eventStore.defaultCalendarForNewEvents?.source
        let local = eventStore.sources.first(where: { $0.sourceType == .local })
        return basic ?? local
    }

    private func loadCalendars() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.calendars = self.eventStore.calendars(for: .event)
        }
    }
}
