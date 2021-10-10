//
//  Faculty.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import Foundation

struct Faculty: Identifiable {
    let name: String
    let url: String

    var id: String { url }
}
