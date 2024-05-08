//
//  Date+Extensions.swift
//  SDKCore
//
// 
//

import Foundation

extension Date {

    func formatDate(dateFormatter: DateFormatter) -> String {
        let formattedDate = dateFormatter.string(from: self)
        let index = formattedDate.index(formattedDate.endIndex, offsetBy: -2)
        let formattedTime = formattedDate[..<index] + ":" + formattedDate[index...]
        return String(formattedTime)
    }

    func toStringExpDate() -> String {
        let calendar = Calendar.current
        let month = String(format: "%02d", calendar.component(.month, from: self))
        let year = calendar.component(.year, from: self) % 100
        return "\(month)/\(year)"
    }
}
