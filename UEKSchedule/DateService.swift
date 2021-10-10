//
//  DateService.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import Foundation

final class DateService {
    static let shared = DateService()
    private let formatter: DateFormatter

    private init() {
        formatter = DateFormatter()
        formatter.dateFormat = "yy-MM-dd"
    }

    func getDate(from string: String) -> Date? {
        formatter.date(from: string)
    }
}

