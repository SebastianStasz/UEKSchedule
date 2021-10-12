//
//  ScheduleVM.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import Combine
import Foundation

final class ScheduleVM: ObservableObject {

    struct Input {
        let updateCalendar = PassthroughSubject<Void, Never>()
        let createCalendar = PassthroughSubject<Void, Never>()
    }

    private var cancellables: Set<AnyCancellable> = []
    private let calendarService: CalendarService
    private let service = ScheduleService()
    let facultyGroup: ScheduleGroup
    let input = Input()

    @Published var navigator = ScheduleNavigator()
    @Published private(set) var calendarExists = false
    @Published private(set) var isLoading = false
    @Published private(set) var events: [Event] = []

    init(facultyGroup: ScheduleGroup) {
        self.facultyGroup = facultyGroup
        self.calendarService = .init(facultyGroup: facultyGroup)

        service.getEvents(for: facultyGroup)
            .assign(to: &$events)

        calendarService.$calendar
            .map { $0 != nil }
            .assign(to: &$calendarExists)

        let creatingCalendar = input.createCalendar
            .asyncMap { [weak self] _ -> ScheduleNavigator.Popup? in
                guard let self = self,
                      await self.hasCalendarAccess(),
                      let error = await self.calendarService.createCalendar(with: self.events)
                else { return nil }
                return .failedToCreateCalendar(error)
            }

        let updatingCalendar = input.updateCalendar
            .asyncMap { [weak self] _ -> ScheduleNavigator.Popup? in
                guard let self = self,
                      await self.hasCalendarAccess(),
                      let error = await self.calendarService.updateCalendar(with: self.events)
                else { return nil }
                return .failedToUpdateCalendar(error)
            }

        Publishers.Merge(creatingCalendar, updatingCalendar)
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
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
}
