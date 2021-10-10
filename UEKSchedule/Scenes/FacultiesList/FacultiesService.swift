//
//  FacultiesService.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import Foundation
import SwiftSoup

final class FacultiesService {

    private let scheduleUrl = "https://planzajec.uek.krakow.pl/index.php"
    private let apiService: APIService

    init(apiService: APIService = .shared) {
        self.apiService = apiService
    }

    func fetchFaculties() async -> [ScheduleGroup] {
        guard let webContent = await apiService.getWebContent(from: scheduleUrl) else {
            return []
        }
        return parseFaculties(from: webContent)
    }

    private func parseFaculties(from content: Document) -> [ScheduleGroup] {
        guard let groups = try? content.getElementsByClass("kategorie").array().second,
              let faculties = try? groups.select("a").array()
        else { return [] }
        return faculties.compactMap { ScheduleGroup.create(from: $0) }
    }
}
