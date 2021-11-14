//
//  FacultyGroupEntity.swift
//  UEKScheduleCoreData
//
//  Created by Sebastian Staszczyk on 09/11/2021.
//

import Foundation
import CoreData

@objc(FacultyGroupEntity)
public class FacultyGroupEntity: NSManagedObject, Entity {
    @NSManaged public private(set) var name: String
    @NSManaged public private(set) var url: String
    @NSManaged public private(set) var calendarId: String
    @NSManaged public private(set) var lastUpdate: Date
}

// MARK: - Methods

public extension FacultyGroupEntity {

    @discardableResult static func create(facultyGroupData data: FacultyGroupData, in context: NSManagedObjectContext) -> FacultyGroupEntity {
        let facultyGroup = FacultyGroupEntity(context: context)
        facultyGroup.name = data.name
        facultyGroup.url = data.urlStr
        facultyGroup.calendarId = data.calendarId
        facultyGroup.lastUpdate = data.lastUpdate
        return facultyGroup
    }

    func modify(lastUpdate: Date) {
        self.lastUpdate = lastUpdate
    }
}

// MARK: - Helpers

extension FacultyGroupEntity: Identifiable {}
