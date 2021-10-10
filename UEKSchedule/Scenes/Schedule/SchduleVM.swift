//
//  SchduleVM.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import EventKit
import Foundation
import SwiftSoup

final class SchduleVM: ObservableObject {
    private let eventStore = EKEventStore()
    @Published private(set) var events: [Event] = []
    @Published var facultyGroup: ScheduleGroup?
    @Published var noCalendarAccessPopup = false

    private func getEvents() {
        $facultyGroup
            .compactMap { $0 }
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

    func checkCalendarAccess() async {
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            getEvents()
        case .notDetermined:
            await requestAccessToCalendar()
        default:
            noCalendarAccessPopup = true
        }
    }

    private func requestAccessToCalendar() async {
        _ = try? await eventStore.requestAccess(to: .event)
        await checkCalendarAccess()
    }
}
