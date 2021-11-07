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
    case common_about
    case common_email
    case about_appDescription
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

    static func schedule_foundedEvents(count: Int) -> String {
        Language.schedule_foundedEvents.text.localize(value: count)
    }
}
