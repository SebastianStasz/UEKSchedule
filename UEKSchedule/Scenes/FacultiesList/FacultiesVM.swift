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

    @Published private(set) var faculties: [ScheduleGroup] = []
    @Published private(set) var isLoading = true
    @Published var search = ""
    let loadFaculties = PassthroughSubject<Void, Never>()

    private var cancellables: Set<AnyCancellable> = []
    private let scheduleUrl = "https://planzajec.uek.krakow.pl/index.php"

    init() {
        let faculties = loadFaculties
            .handleEvents(receiveOutput: { [weak self] in
                self?.faculties = []
                self?.isLoading = true
            })
            .asyncMap { [weak self] in
                await self?.fetchFaculties()
            }
            .compactMap { $0 }

        Publishers.CombineLatest(faculties, $search)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _, _ in
                self?.isLoading = false
            })
            .map { faculties, searchText in
                searchText.isEmpty
                    ? faculties
                    : faculties.filter { $0.name.contains(searchText) }
            }
            .assign(to: &$faculties)
    }

    private func fetchFaculties() async -> [ScheduleGroup] {
        guard let webContent = await APIService.shared.getWebContent(from: scheduleUrl) else {
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
