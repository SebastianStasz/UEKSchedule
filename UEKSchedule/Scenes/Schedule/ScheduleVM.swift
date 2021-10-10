//
//  ScheduleVM.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import Combine
import EventKit
import Foundation
import SwiftSoup

final class ScheduleVM: ObservableObject {

    @Published private var calendarService: CalendarService
    let facultyGroup: ScheduleGroup

    @Published private(set) var events: [Event] = []
    @Published var noCalendarAccessPopup = false
    @Published private(set) var calendarExists = false

    init(facultyGroup: ScheduleGroup) {
        self.facultyGroup = facultyGroup
        self.calendarService = .init(facultyGroup: facultyGroup)

        calendarService.$calendar
            .map { $0 != nil }
            .assign(to: &$calendarExists)
    }

    func createCalendar() {
        calendarService.createCalendar()
    }

    func checkCalendarAccess() async {
        guard await calendarService.checkCalendarAccess() else {
            noCalendarAccessPopup = true
            return
        }
        getEvents()
    }

    private func getEvents() {
        Just(facultyGroup)
            .asyncMap { [weak self] facultyGroup in
                var url = "https://planzajec.uek.krakow.pl/" + facultyGroup.url
                url.removeLast()
                url += "2"
                return await self?.fetchEvents(from: url)
            }
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .assign(to: &$events)
    }

    private func fetchEvents(from url: String) async -> [Event] {
        guard let webContent = await APIService.shared.getWebContent(from: url) else {
            return []
        }
        return parseEvents(from: webContent)
    }

    private func parseEvents(from content: Document) -> [Event] {
        guard let table = try? content.select("table").first(),
              let rows = try? table.select("tr").array()
        else { return [] }

        return rows.compactMap { getEvent(from: $0) }
    }

    private func getEvent(from row: Element) -> Event? {
        do {
            let columns = try row.select("td").array()
            guard columns.count == 6 else { return nil }
//            let term = try columns[0].text()
//            let time = try columns[1].text()
            let name = try columns[2].text()
            let type = try columns[3].text()
            let leader = try columns[4].text()
            let place = try columns[5].text()
            return Event(name: name, type: type, leader: leader, place: place, term: Date())
        } catch {
            return nil
        }
    }
}
