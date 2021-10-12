//
//  AppError.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 12/10/2021.
//

import Foundation

enum AppError: String {
    case getCalendarSource = "#001"
    case createCalendar = "#002"
    case updateCalendar = "#003"

    var code: String { rawValue }
}
