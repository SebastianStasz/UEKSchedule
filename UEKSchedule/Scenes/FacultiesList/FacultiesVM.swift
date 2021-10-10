//
//  FacultiesVM.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import Combine
import Foundation

final class FacultiesVM: ObservableObject {

    private let service = FacultiesService()
    let loadFaculties = PassthroughSubject<Void, Never>()

    @Published private(set) var faculties: [ScheduleGroup] = []
    @Published private(set) var isLoading = true
    @Published var search = ""

    init() {
        let faculties = loadFaculties
            .handleEvents(receiveOutput: { [weak self] in
                self?.faculties = []
                self?.isLoading = true
            })
            .asyncMap { [weak self] in
                await self?.service.fetchFaculties()
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
}
