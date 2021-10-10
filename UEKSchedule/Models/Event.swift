//
//  Event.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import Foundation

struct Event {
    let name: String
    let type: String
    let leader: String
    let place: String
    let term: String
    let time: String

    var description: String {
        "Typ: \(type)\nNauczyciel: \(leader)"
    }

    private var date: Date? {
        DateService.shared.getDate(from: term)
    }

    var startDate: Date? {
        guard let startHour = Int(time.substring(with: 3..<5)),
              let startMinutes = Int(time.substring(with: 6..<8)),
              let date = date,
              let startDate = Calendar.current.date(bySettingHour: startHour, minute: startMinutes, second: 0, of: date)
        else { return nil }
        return startDate
    }

    var endDate: Date? {
        guard let endHour = Int(time.substring(with: 11..<13)),
              let endMinutes = Int(time.substring(with: 14..<16)),
              let date = date,
              let endDate = Calendar.current.date(bySettingHour: endHour, minute: endMinutes, second: 0, of: date)
        else { return nil }
        return endDate
    }
}

extension Event: Identifiable, Hashable {
    var id: Int { self.hashValue }
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}
