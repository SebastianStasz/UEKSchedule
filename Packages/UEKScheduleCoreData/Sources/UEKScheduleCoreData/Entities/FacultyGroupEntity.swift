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

    @discardableResult func create(facultyGroup: FacultyGroup, in context: NSManagedObjectContext) -> FacultyGroupEntity {
        let facultyGroup = FacultyGroupEntity(context: context)
        facultyGroup.name = facultyGroup.name
        facultyGroup.url = facultyGroup.url
        return facultyGroup
    }
}

// MARK: - Helpers

extension FacultyGroupEntity: Identifiable {}
