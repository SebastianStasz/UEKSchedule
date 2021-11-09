//
//  NSManagedObject+Ext.swift
//  UEKScheduleCoreData
//
//  Created by Sebastian Staszczyk on 09/11/2021.
//

import CoreData

extension NSManagedObject {

    /// Returns a description of search criteria used to retrieve data from a persistent store.
    /// - Parameters:
    ///   - sortDescriptors: The sort descriptors of the fetch request.
    ///   - predicate: The predicate of the fetch request.
    /// - Returns: A description of search criteria as `NSFetchRequest`.
    public static func nsFetchRequest<T: NSManagedObject>(sortDescriptors: [NSSortDescriptor] = [], predicate: NSPredicate? = nil) -> NSFetchRequest<T> {
        let name = String(describing: type(of: T.self)).replacingOccurrences(of: ".Type", with: "")
        let request = NSFetchRequest<T>(entityName: name)
        request.sortDescriptors = sortDescriptors
        request.predicate = predicate
        return request
    }
}
