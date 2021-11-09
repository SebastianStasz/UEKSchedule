//
//  EntitySort.swift
//  UEKScheduleCoreData
//
//  Created by Sebastian Staszczyk on 09/11/2021.
//

import CoreData
import Foundation

public protocol EntitySort {
    associatedtype Entity: NSManagedObject

    var get: SortDescriptor<Entity> { get }
}

extension EntitySort {
    var asNSSortDescriptor: NSSortDescriptor {
        NSSortDescriptor(get)
    }
}
