//
//  FacultyGroupsVM.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import Combine
import Foundation
import SwiftSoup

final class FacultyGroupsVM: ObservableObject {

    @Published var faculty: ScheduleGroup?
    @Published private(set) var facultyGroups: [ScheduleGroup] = []

    init() {
        $faculty
            .compactMap { $0 }
            .asyncMap { [weak self] faculty in
                let url = "https://planzajec.uek.krakow.pl/" + faculty.url
                return await self?.fetchFacultyGroups(from: url)
            }
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .assign(to: &$facultyGroups)
    }

    private func fetchFacultyGroups(from url: String) async -> [ScheduleGroup] {
        guard let webContent = await APIService.shared.getWebContent(from: url) else { return [] }
        let facultyGroups = parseFacultyGroups(from: webContent)
        return facultyGroups
    }

    private func parseFacultyGroups(from content: Document) -> [ScheduleGroup] {
        guard let columns = try? content.getElementsByClass("kolumna").array() else { return [] }
        let groups = columns.compactMap { try? $0.select("a") }.flatMap { $0 }
        return groups.compactMap { ScheduleGroup.create(from: $0) }
    }
}
