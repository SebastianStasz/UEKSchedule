//
//  ScheduleGroup.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import Foundation
import SwiftSoup

struct ScheduleGroup {
    let name: String
    let url: String
}

extension ScheduleGroup: Identifiable {
    var id: String { url }
}

extension ScheduleGroup {
    static func create(from element: Element) -> ScheduleGroup? {
        guard let link = try? element.attr("href"),
              let name = try? element.text()
        else { return nil }
        return ScheduleGroup(name: name, url: link)
    }
}


// MARK: - Sample Data

extension ScheduleGroup {
    static let sampleFaculty = ScheduleGroup(name: "Informatyka Stosowana", url: "https://planzajec.uek.krakow.pl/index.php?typ=G&grupa=Informatyka%20Stosowana")
    static let sampleFacultyGroup = ScheduleGroup(name: "ZZISS1-3512IO", url: "https://planzajec.uek.krakow.pl/index.php?typ=G&id=184261&okres=2")
}
