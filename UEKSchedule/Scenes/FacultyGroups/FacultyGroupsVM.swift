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

    @Published private(set) var facultyGroups: [ScheduleGroup] = []
    @Published var scheduleVM: ScheduleVM?
    @Published var faculty: ScheduleGroup?
    @Published var search = ""

    init() {
        let facultyGroups = $faculty
            .compactMap { $0 }
            .asyncMap { [weak self] faculty -> [ScheduleGroup]? in
                let url = "https://planzajec.uek.krakow.pl/" + faculty.url
                return await self?.fetchFacultyGroups(from: url)
            }
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)

        Publishers.CombineLatest(facultyGroups, $search)
            .map { facultyGroups, searchText in
                searchText.isEmpty
                    ? facultyGroups
                    : facultyGroups.filter { $0.name.contains(searchText) }
            }
            .assign(to: &$facultyGroups)
    }

    private func fetchFacultyGroups(from url: String) async -> [ScheduleGroup] {
        guard let webContent = await APIService.shared.getWebContent(from: url) else {
            return []
        }
        return parseFacultyGroups(from: webContent)
    }

    private func parseFacultyGroups(from content: Document) -> [ScheduleGroup] {
        guard let columns = try? content.getElementsByClass("kolumna").array() else {
            return []
        }
        let groups = columns.compactMap { try? $0.select("a") }.flatMap { $0 }
        return groups.compactMap { ScheduleGroup.create(from: $0) }
    }
}
