//
//  Date + Extension.swift
//  TaskManager
//
//  Created by Berke Üçvet on 17.03.2023.
//

import Foundation

extension Date {
    var stringOfMonthAndDay: String? {
        "\(Calendar.current.component(.day, from: self))/\(Calendar.current.component(.month, from: self))"
    }
    
    static func from(year: Int? = nil, month: Int? = nil, day: Int? = nil) -> Date? {
        let now = Date()
        var dateComponents = DateComponents()
        dateComponents.year = year ?? Calendar.current.component(.year, from: now)
        dateComponents.month = month ?? Calendar.current.component(.month, from: now)
        dateComponents.day = day ?? Calendar.current.component(.day, from: now)
        return Calendar.current.date(from: dateComponents) ?? nil
    }
    
    static func fromMonthAndDayString(mAndD: String) -> Date? {
        let monthAndDay = mAndD.split(separator: "/")
        return self.from(month: Int(monthAndDay[0]), day: Int(monthAndDay[0]))
    }
}
