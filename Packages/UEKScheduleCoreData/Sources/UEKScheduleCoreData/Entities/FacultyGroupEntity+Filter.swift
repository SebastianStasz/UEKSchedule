//
//  FacultyGroupEntity+Filter.swift
//  UEKScheduleCoreData
//
//  Created by Sebastian Staszczyk on 09/11/2021.
//

import Foundation

public extension FacultyGroupEntity {

    enum Filter: EntityFilter {
        case byName(String)
        case byCalendarId(String)

        public var nsPredicate: NSPredicate? {
            switch self {
            case .byName(let name):
                return NSPredicate(format: "name == %@", name)
            case .byCalendarId(let id):
                return NSPredicate(format: "calendarId == %@", id)
            }
        }
    }
}
