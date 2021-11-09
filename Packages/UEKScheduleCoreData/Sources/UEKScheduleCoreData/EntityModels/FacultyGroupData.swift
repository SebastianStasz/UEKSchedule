//
//  FacultyGroupData.swift
//  UEKScheduleCoreData
//
//  Created by Sebastian Staszczyk on 09/11/2021.
//

import Foundation

public struct FacultyGroupData {
    public let name: String
    public let urlStr: String
    public let lastUpdate: Date
}

public extension FacultyGroupData {
    var url: URL? {
        URL(string: urlStr)
    }
}


// MARK: - Sample Data

extension FacultyGroupData {
    static let sample1 = FacultyGroupData(name: "ZZISS1-3512IO", urlStr: "https://planzajec.uek.krakow.pl/index.php?typ=G&id=184261&okres=2", lastUpdate: Date())
}
