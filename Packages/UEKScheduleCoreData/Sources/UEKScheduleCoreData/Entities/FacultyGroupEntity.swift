//
//  FacultyGroupEntity.swift
//  UEKScheduleCoreData
//
//  Created by Sebastian Staszczyk on 09/11/2021.
//

import Foundation
import CoreData

@objc(FacultyGroupEntity)
public class FacultyGroupEntity: NSManagedObject {
    @NSManaged public private(set) var name: String
    @NSManaged public private(set) var url: String
}

// MARK: - Methods

public extension FacultyGroupEntity {

    @discardableResult static func create(facultyGroupData: FacultyGroupData, in context: NSManagedObjectContext) -> FacultyGroupEntity {
        let facultyGroup = FacultyGroupEntity(context: context)
        facultyGroup.name = facultyGroupData.name
        facultyGroup.url = facultyGroupData.urlStr
        return facultyGroup
    }
}

// MARK: - Helpers

extension FacultyGroupEntity: Identifiable {}
