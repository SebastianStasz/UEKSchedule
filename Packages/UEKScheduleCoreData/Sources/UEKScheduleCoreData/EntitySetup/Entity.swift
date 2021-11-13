//
//  Entity.swift
//  UEKScheduleCoreData
//
//  Created by Sebastian Staszczyk on 09/11/2021.
//

import CoreData
import Foundation
import SwiftUI

public protocol Entity {
    associatedtype Filter: EntityFilter
    associatedtype Sort: EntitySort
}

public extension Entity where Sort.Entity == Self {
    static func getAll(sorting: [Sort] = [], filtering: [Filter]? = nil) -> FetchRequest<Self> {
        let request = getAllNSFetch(sorting: sorting, filtering: filtering)
        return FetchRequest(fetchRequest: request)
    }

    static func getAllNSFetch(sorting: [Sort] = [], filtering: [Filter]? = nil) -> NSFetchRequest<Self> {
        let sortDescriptors = sorting.map { $0.asNSSortDescriptor }
        let request: NSFetchRequest<Self> = Self.nsFetchRequest(sortDescriptors: sortDescriptors)
        if let predicates = filtering?.compactMap({ $0.nsPredicate }) {
            request.predicate = NSCompoundPredicate(type: .and, subpredicates: predicates)
        }
        return request
    }
}
