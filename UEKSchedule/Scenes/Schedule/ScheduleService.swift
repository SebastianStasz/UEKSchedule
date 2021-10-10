//
//  ScheduleService.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import Combine
import Foundation
import SwiftSoup

final class ScheduleService {

    func getEvents(for facultyGroup: ScheduleGroup) -> AnyPublisher<[Event], Never> {
        Just(facultyGroup)
            .asyncMap { [weak self] facultyGroup in
                var url = "https://planzajec.uek.krakow.pl/" + facultyGroup.url
                url.removeLast()
                url += "2"
                return await self?.fetchEvents(from: url)
            }
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
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
            let term = try columns[0].text()
            let time = try columns[1].text()
            let name = try columns[2].text()
            let type = try columns[3].text()
            let leader = try columns[4].text()
            let place = try columns[5].text()
            return Event(name: name, type: type, leader: leader, place: place, term: term, time: time)
        } catch {
            return nil
        }
    }
}
