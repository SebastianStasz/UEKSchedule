//
//  FacultyGroupsService.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import Foundation
import SwiftSoup

final class FacultyGroupsService {

    private let apiService: APIService

    init(apiService: APIService = .shared) {
        self.apiService = apiService
    }

    func fetchFacultyGroups(facultyUrl: String) async -> [ScheduleGroup] {
        let url = "https://planzajec.uek.krakow.pl/" + facultyUrl
        guard let webContent = await apiService.getWebContent(from: url) else {
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
