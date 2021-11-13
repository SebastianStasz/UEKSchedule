//
//  FacultyGroupEntity+Sort.swift
//  UEKScheduleCoreData
//
//  Created by Sebastian Staszczyk on 09/11/2021.
//

import Foundation

public extension FacultyGroupEntity {

    enum Sort: EntitySort {
        case byName(SortOrder = .reverse)

        public var get: SortDescriptor<Entity> {
            switch self {
            case let .byName(order):
                return SortDescriptor(\Entity.name, order: order)
            }
        }

        public typealias Entity = FacultyGroupEntity
    }
}
