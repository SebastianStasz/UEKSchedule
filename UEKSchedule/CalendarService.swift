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
    private let calendarSource: EKSource?

    @Published private(set) var calendar: EKCalendar?
    @Published private(set) var calendars: [EKCalendar] = []

    init(facultyGroup: ScheduleGroup) {
        self.facultyGroup = facultyGroup

        let basic = eventStore.defaultCalendarForNewEvents?.source
        let local = eventStore.sources.first(where: { $0.sourceType == .local })
        calendarSource = basic ?? local

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

    func createCalendar(with events: [Event]) {
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.createEvents(events: events)
            }
        } catch {
            print("Failed to create calendar")
        }
    }

    func updateCalendar(with events: [Event]) {
        deleteEvents()
        createEvents(events: events)
    }

    private func createEvents(events: [Event]) {
        for event in events {
            createEvent(from: event)
        }
    }

    private func deleteEvents() {
        let date = Date()
        let startDate = Calendar.current.date(byAdding: .year, value: -1, to: date)!
        let endDate = Calendar.current.date(byAdding: .year, value: 1, to: date)!
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: [calendar!])
        let events = eventStore.events(matching: predicate)
        for event in events {
            try? eventStore.remove(event, span: .thisEvent)
        }
    }

    private func createEvent(from eventData: Event) {
        guard let startDate = eventData.startDate,
              let endDate = eventData.endDate
        else { return }
        let event = EKEvent(eventStore: eventStore)
        event.calendar = calendar
        event.title = eventData.name
        event.location = eventData.place
        event.notes = eventData.description
        event.startDate = startDate
        event.endDate = endDate
        do {
            try eventStore.save(event, span: .thisEvent)
        } catch {
            print("Failed to create event \(eventData.name)")
            print(error)
        }
    }

    private func loadCalendars() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.calendars = self.eventStore.calendars(for: .event)
        }
    }
}
