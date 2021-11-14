//
//  FacultyGroupEntityTests.swift
//  UEKScheduleCoreData
//
//  Created by Sebastian Staszczyk on 09/11/2021.
//

import XCTest
@testable import UEKScheduleCoreData

final class FacultyGroupEntityTests: XCTestCase, CoreDataSteps {

    var context = PersistenceController.previewEmpty.context

    override func setUpWithError() throws {
        context.reset()
        context = PersistenceController.previewEmpty.context
    }

    // MARK: - Tests

    func test_faculty_group_entity() throws {
        // Define faculty group data.
        let facultyGroupData = FacultyGroupData.sample1

        // Before creating, there should not be any faculty groups.
        try fetchRequestShouldReturnElements(0, for: FacultyGroupEntity.self)

        // Create faculty group entity using defined data.
        let facultyGroupEntity = createFacultyGroupEntity(data: facultyGroupData)

        // After creating, there should be one faculty group entity.
        try fetchRequestShouldReturnElements(1, for: FacultyGroupEntity.self)

        // Verify that body parameter entity data is correct.
        try verifyFacultyGroupData(in: facultyGroupEntity, data: facultyGroupData)

        // Save context.
        try saveContext()
    }

    func test_modify_faculty_group_entity() throws {
        // Create faculty group entity using sample data.
        let facultyGroupEntity = createFacultyGroupEntity(data: .sample1)

        // Create new date to update faculty group entity.
        let newDate = Date()

        // Modify faculty group entity.
        facultyGroupEntity.modify(lastUpdate: newDate)

        // Verify that group entity entity was modified.
        try verifyFacultyGroupData(in: facultyGroupEntity, data: .sample1, lastUpdate: newDate)

        // Save context.
        try saveContext()
    }

    func test_delete_faculty_group_entity() throws {
        // Create faculty group entity using sample data.
        let facultyGroupEntity = createFacultyGroupEntity(data: .sample1)

        // Delete faculty group entity.
        facultyGroupEntity.delete()

        // Verify that group entity entity was deleted.
        try fetchRequestShouldReturnElements(0, for: FacultyGroupEntity.self)

        // Save context.
        try saveContext()
    }
}

// MARK: - Steps

private extension FacultyGroupEntityTests {
    func createFacultyGroupEntity(data: FacultyGroupData) -> FacultyGroupEntity {
        FacultyGroupEntity.create(facultyGroupData: data, in: context)
    }

    func verifyFacultyGroupData(in entity: FacultyGroupEntity, data: FacultyGroupData, lastUpdate: Date? = nil) throws {
        XCTAssertEqual(entity.name, data.name)
        XCTAssertEqual(entity.url, data.urlStr)
        XCTAssertEqual(entity.lastUpdate, lastUpdate ?? data.lastUpdate)
        XCTAssertEqual(entity.calendarId, data.calendarId)
    }
}
