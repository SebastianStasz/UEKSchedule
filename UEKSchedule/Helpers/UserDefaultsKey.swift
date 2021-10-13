//
//  UserDefaultsKey.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 12/10/2021.
//

import Foundation

enum UserDefaultsKey: String {
    case calendarExists
    case calendarLastUpdate

    var key: String { rawValue }
}

extension String {

    static func UD_calendarExists(withUrl url: String) -> String {
        UserDefaultsKey.calendarExists.key + url
    }

    static func UD_calendarLastUpdate(withUrl url: String) -> String {
        UserDefaultsKey.calendarLastUpdate.key + url
    }
}
