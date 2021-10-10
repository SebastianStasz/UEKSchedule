//
//  ScheduleScrapper.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 09/10/2021.
//

import Foundation
import SwiftSoup

struct Event {
    let name: String
    let type: String
    let leader: String
    let place: String
    let term: Date
}

final class ScheduleScrapper: ObservableObject {

    private let url = "http://planzajec.uek.krakow.pl/index.php?typ=G&id=184261&okres=1"

    func scrapSchedule() {
        guard let webContent = getWebContent(from: url) else {
            print("Getting web content error") ; return
        }
        guard let html = try? SwiftSoup.parse(webContent) else {
            print("Parsing web content error") ; return
        }

        do {
            let table = try html.select("table").first()
            guard let rows = try table?.select("tr").array() else {
                print("Parsing rows error") ; return
            }

            let events = rows.map { getEvent(from: $0) }

            print(events)
        } catch {
            print(error)
        }
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

    private func getWebContent(from url: String) -> String? {
        guard let url = URL(string: url),
              let webContent = try? String(contentsOf: url)
        else { return nil }
        return webContent
    }
}
