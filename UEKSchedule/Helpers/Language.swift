//
//  Language.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 12/10/2021.
//

import Foundation

enum Language: String {
    case common_appName
    case common_ok
    case common_faculties
    case common_showAll
    case common_about
    case common_email
    case common_cancel
    case common_delete
    case common_all
    case common_observed

    case about_appDescription

    case faculties_empty
    case faculties_search_empty
    
    case schedule_createCalendar
    case schedule_updateCalendar
    case schedule_deleteCalendar
    case schedule_foundedEvents
    case schedule_lastUpdate
    case schedule_calendarExists
    case schedule_deleteCalendar_message

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

    func localize(str: String) -> String {
        String(format: self.localize, str)
    }
}

extension String {
    static let common_appName = Language.common_appName.text
    static let common_delete = Language.common_delete.text
    static let common_cancel = Language.common_cancel.text
    static let schedule_deleteCalendar = Language.schedule_deleteCalendar.text
    static func schedule_foundedEvents(count: Int) -> String {
        Language.schedule_foundedEvents.text.localize(value: count)
    }
    static func schedule_lastUpdate(_ date: String) -> String {
        Language.schedule_lastUpdate.text.localize(str: date)
    }
    static func schedule_deleteCalendar_message(calendarName: String) -> String {
        Language.schedule_deleteCalendar_message.text.localize(str: calendarName)
    }
}
