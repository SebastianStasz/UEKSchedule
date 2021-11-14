//
//  ScheduleVM.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import Combine
import Foundation
import UEKScheduleCoreData

final class ScheduleVM: ObservableObject {

    struct Input {
        let updateCalendar = PassthroughSubject<Void, Never>()
        let createCalendar = PassthroughSubject<Void, Never>()
        let deleteCalendar = PassthroughSubject<Void, Never>()
        let showDeleteCalendarAlert = PassthroughSubject<Void, Never>()
        let returnFromBackground = PassthroughSubject<Void, Never>()
    }

    private var cancellables: Set<AnyCancellable> = []
    private let calendarService: CalendarService
    private let service = ScheduleService()
    let facultyGroup: ScheduleGroup
    let input = Input()

    @Published var navigator = ScheduleNavigator()
    @Published private(set) var calendarExists = false
    @Published private(set) var isLoading = false
    @Published private(set) var isCalendarUpdating = false
    @Published private(set) var events: [Event] = []
    @Published private(set) var eventGroups: [EventGroup] = []

    var calendarLastUpdate: Date? {
        calendarService.facultyGroupEntity?.lastUpdate
    }

    var calendarName: String? {
        calendarService.calendar?.title
    }

    init(facultyGroup: ScheduleGroup) {
        self.facultyGroup = facultyGroup
        self.calendarService = .init(facultyGroup: facultyGroup)

        service.getEvents(for: facultyGroup)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isLoading = true
            })
            .assign(to: &$events)

        $events
            .compactMap { [weak self] events in
                self?.sortByDate(classes: events)
            }
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isLoading = false
            })
            .assign(to: &$eventGroups)

        calendarService.$calendar
            .map { $0 != nil }
            .assign(to: &$calendarExists)

        let creatingCalendar = input.createCalendar
            .asyncMap { [weak self] _ -> ScheduleNavigator.Popup? in
                guard let self = self,
                      await self.hasCalendarAccess(),
                      let error = self.calendarService.createCalendar(with: self.events)
                else { return nil }
                return .failedToCreateCalendar(error)
            }

        let updatingCalendar = input.updateCalendar
            .asyncMap { [weak self] _ -> ScheduleNavigator.Popup? in
                guard let self = self,
                      await self.hasCalendarAccess(),
                      let error = self.calendarService.updateCalendar(with: self.events)
                else { return nil }
                return .failedToUpdateCalendar(error)
            }

        input.showDeleteCalendarAlert
            .sink { [weak self] in
                self?.navigator.navigate(to: .showDeleteCalendarAlert)
            }
            .store(in: &cancellables)

        input.deleteCalendar
            .asyncMap { [weak self] _ -> ScheduleNavigator.Popup? in
                guard let self = self,
                      await self.hasCalendarAccess(),
                      let error = self.calendarService.deleteCalendar()
                else { return nil }
                return .failedToDeleteCalendar(error)
            }
            .sink { _ in }
            .store(in: &cancellables)

        input.returnFromBackground
            .sink { [weak self] in
                self?.calendarService.loadCalendars()
            }
            .store(in: &cancellables)

        Publishers.Merge(input.createCalendar, input.updateCalendar)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.isCalendarUpdating = true
            }
            .store(in: &cancellables)

        Publishers.Merge(creatingCalendar, updatingCalendar)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isCalendarUpdating = false
            })
            .compactMap { $0 }
            .sink { [weak self] in
                self?.navigator.navigate(to: .aler($0))
            }
            .store(in: &cancellables)
    }

    private func hasCalendarAccess() async -> Bool {
        guard await calendarService.checkCalendarAccess() else {
            navigator.navigate(to: .aler(.noCalendarAccess))
            return false
        }
        return true
    }

    private func sortByDate(classes: [Event]) -> [EventGroup] {
        var term = events.first?.term
        var events: [Event] = []
        var eventGroups: [EventGroup] = []
        for event in classes {
            if event.term == term {
                events.append(event)
            } else {
                let eventGroup = EventGroup(title: term ?? "", events: events)
                eventGroups.append(eventGroup)
                events = []
                term = event.term
                events.append(event)
            }
        }

        return eventGroups
    }
}

extension ScheduleVM {
    convenience init(facultyGroupEntity: FacultyGroupEntity) {
        self.init(facultyGroup: .init(name: facultyGroupEntity.name, url: facultyGroupEntity.url))
    }
}
