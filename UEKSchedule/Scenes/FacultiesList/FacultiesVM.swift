//
//  FacultiesVM.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import Combine
import Foundation
import SwiftSoup

final class FacultiesVM: ObservableObject {

    @Published private var allFaculties: [ScheduleGroup] = []
    @Published private(set) var faculties: [ScheduleGroup] = []
    @Published private(set) var isLoading = true
    @Published var search = ""

    private var cancellables: Set<AnyCancellable> = []
    private let scheduleUrl = "https://planzajec.uek.krakow.pl/index.php"

    init() {
        Publishers.CombineLatest($allFaculties, $search)
            .map { faculties, searchText in
                searchText.isEmpty
                    ? faculties
                    : faculties.filter { $0.name.contains(searchText) }
            }
            .assign(to: &$faculties)
    }

    func loadFaculties() async {
        allFaculties = []
        isLoading = true
        await fetchFaculties()
    }

    private func fetchFaculties() async {
        guard let webContent = await APIService.shared.getWebContent(from: scheduleUrl) else { return }
        let faculties = parseFaculties(from: webContent)
        DispatchQueue.main.async { [weak self] in
            self?.allFaculties = faculties
            self?.isLoading = false
        }
    }

    private func parseFaculties(from content: Document) -> [ScheduleGroup] {
        guard let groups = try? content.getElementsByClass("kategorie").array().second,
              let faculties = try? groups.select("a").array()
        else { return [] }
        return faculties.compactMap { ScheduleGroup.create(from: $0) }
    }
}
