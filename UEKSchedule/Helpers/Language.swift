//
//  Language.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 12/10/2021.
//

import Foundation

enum Language: String {
    case common_ok
    case common_faculties
    case common_showAll
    case faculties_empty
    case faculties_search_empty
    case schedule_createCalendar
    case schedule_updateCalendar
    case schedule_foundedEvents
    case schedule_calendarExists

    var text: String {
        rawValue.localize
    }
}

extension String {
    var localize: String {
        NSLocalizedString(self, comment: self)
    }

    func localize(value: Int) -> String {
        String(format: self.localize, value)
    }
}

extension String {
    static let common_ok = Language.common_ok.text
    static let common_faculties = Language.common_faculties.text
    static let common_showAll = Language.common_showAll.text
    static let faculties_empty = Language.faculties_empty.text
    static let faculties_search_empty = Language.faculties_search_empty.text
    static let schedule_createCalendar = Language.schedule_createCalendar.text
    static let schedule_updateCalendar = Language.schedule_updateCalendar.text
    static let schedule_calendarExists = Language.schedule_calendarExists.text

    static func schedule_foundedEvents(count: Int) -> String {
        Language.schedule_foundedEvents.text.localize(value: count)
    }
}
