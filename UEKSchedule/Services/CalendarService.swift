//
//  CalendarService.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import UEKScheduleCoreData
import EventKit
import Foundation
import CoreData

final class CalendarService {
    private var eventStore = EKEventStore()
    private let facultyGroup: ScheduleGroup
    private var calendarSource: EKSource?

    @Published private var calendars: [EKCalendar] = []
    @Published private(set) var facultyGroupEntity: FacultyGroupEntity?
    @Published private(set) var calendar: EKCalendar?
    let context: NSManagedObjectContext

    init(facultyGroup: ScheduleGroup, context: NSManagedObjectContext = PersistenceController.shared.context) {
        self.facultyGroup = facultyGroup
        self.context = context
        setCalendarSource()

        $calendars
            .map { _ -> FacultyGroupEntity? in
                let request = FacultyGroupEntity.getAllNSFetch(filtering: [.byName(facultyGroup.name)])
                return try? context.fetch(request).first
            }
            .assign(to: &$facultyGroupEntity)

        $facultyGroupEntity
            .compactMap { [weak self] facultyGroup in
                self?.eventStore.calendars(for: .event).first { $0.calendarIdentifier == facultyGroup?.calendarId }
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

    func createCalendar(with events: [Event]) -> AppError? {
        guard let source = calendarSource else {
            return AppError.getCalendarSource
        }
        let calendar = EKCalendar(for: .event, eventStore: eventStore)
        calendar.title = facultyGroup.name
        calendar.source = source

        do {
            try eventStore.saveCalendar(calendar, commit: true)
            let data = FacultyGroupData(name: facultyGroup.name, urlStr: facultyGroup.url, calendarId: calendar.calendarIdentifier)
            FacultyGroupEntity.create(facultyGroupData: data, in: context)
            loadCalendars()
            createEvents(events: events, in: calendar)
            return nil
        } catch {
            return AppError.createCalendar
        }
    }

    func updateCalendar(with events: [Event]) -> AppError? {
        guard let calendar = calendar else {
            return .updateCalendar
        }
        facultyGroupEntity?.modify(lastUpdate: Date())
        deleteEvents(in: calendar)
        createEvents(events: events, in: calendar)
        return nil
    }

    func deleteCalendar() -> AppError? {
        guard let calendar = calendar else {
            return .deleteCalendar
        }
        return deleteCalendar(calendar)
    }

    func loadCalendars() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.calendars = self.eventStore.calendars(for: .event)
        }
    }
}

// MARK: - Private

extension CalendarService {

    private func createEvents(events: [Event], in calendar: EKCalendar) {
        for event in events {
            createEvent(from: event, in: calendar)
        }
    }

    private func deleteCalendar(_ calendar: EKCalendar) -> AppError? {
        do {
            facultyGroupEntity?.delete()
            try eventStore.removeCalendar(calendar, commit: true)
            return nil
        } catch {
            return AppError.deleteCalendar
        }
    }

    private func deleteEvents(in calendar: EKCalendar) {
        let date = Date()
        let startDate = Calendar.current.date(byAdding: .year, value: -1, to: date)!
        let endDate = Calendar.current.date(byAdding: .year, value: 1, to: date)!
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: [calendar])
        let events = eventStore.events(matching: predicate)
        for event in events {
            try? eventStore.remove(event, span: .thisEvent)
        }
    }

    private func createEvent(from eventData: Event, in calendar: EKCalendar) {
        guard let startDate = eventData.startDate,
              let endDate = eventData.endDate
        else { return }
        let event = EKEvent(eventStore: eventStore)
        event.calendar = calendar
        event.title = eventData.typeSymbol + ": " + eventData.name
        event.location = eventData.place
        event.notes = eventData.description
        event.startDate = startDate
        event.endDate = endDate
        do {
            try eventStore.save(event, span: .futureEvents)
        } catch {
            print("Failed to create event \(eventData.name)")
            print(error)
        }
    }

    private func requestAccessToCalendar() async -> Bool {
        _ = try? await eventStore.requestAccess(to: .event)
        setCalendarSource()
        return await checkCalendarAccess()
    }

    private func setCalendarSource() {
        eventStore = .init()
        let basic = eventStore.defaultCalendarForNewEvents?.source
        let local = eventStore.sources.first(where: { $0.sourceType == .local })
        calendarSource = basic ?? local
    }
}
