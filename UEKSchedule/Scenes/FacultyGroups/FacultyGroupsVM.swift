//
//  FacultyGroupsVM.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import Combine
import Foundation

final class FacultyGroupsVM: ObservableObject {

    private let service = FacultyGroupsService()

    @Published private(set) var facultyGroups: [ScheduleGroup] = []
    @Published var scheduleVM: ScheduleVM?
    @Published var faculty: ScheduleGroup?
    @Published var search = ""

    init() {
        let facultyGroups = $faculty
            .compactMap { $0 }
            .asyncMap { [weak self] faculty -> [ScheduleGroup]? in
                await self?.service.fetchFacultyGroups(facultyUrl: faculty.url)
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
}
