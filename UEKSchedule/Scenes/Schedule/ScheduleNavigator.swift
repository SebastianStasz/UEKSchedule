//
//  ScheduleNavigator.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 12/10/2021.
//

import Foundation
import SwiftUI

struct ScheduleNavigator {

    var isDeleteCalendarAlertPresented = false

    enum Destination {
        case aler(Popup)
        case showDeleteCalendarAlert
    }

    var alert: Popup?

    mutating func navigate(to destination: Destination) {
        switch destination {
        case .aler(let alert):
            self.alert = alert
        case .showDeleteCalendarAlert:
            isDeleteCalendarAlertPresented = true
        }
    }
}

// MARK: - Alert

extension ScheduleNavigator {

    enum Popup: Identifiable {
        case noCalendarAccess
        case failedToCreateCalendar(AppError)
        case failedToUpdateCalendar(AppError)
        case failedToDeleteCalendar(AppError)

        var body: Alert {
            switch self {
            case .noCalendarAccess:
                return Alert(title: Text("Error"), message: Text("No calendar access."))
            case .failedToCreateCalendar(let error):
                return Alert(title: Text("Error \(error.code)"), message: Text("Failed to create calendar. Try again later."))
            case .failedToUpdateCalendar(let error):
                return Alert(title: Text("Error \(error.code)"), message: Text("Failed to update calendar. Try again later."))
            case .failedToDeleteCalendar(let error):
                return Alert(title: Text("Error \(error.code)"), message: Text("Failed to delete calendar. Try again later."))
            }
        }

        var id: Int {
            switch self {
            case .noCalendarAccess: return 0
            case .failedToCreateCalendar: return 1
            case .failedToUpdateCalendar: return 2
            case .failedToDeleteCalendar: return 3
            }
        }
    }
}
