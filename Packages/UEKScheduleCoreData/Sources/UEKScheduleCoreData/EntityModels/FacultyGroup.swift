//
//  FacultyGroup.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 09/11/2021.
//

import Foundation

public struct FacultyGroup {
    let name: String
    let urlStr: String
}

public extension FacultyGroup {
    var url: URL? {
        URL(string: urlStr)
    }
}
