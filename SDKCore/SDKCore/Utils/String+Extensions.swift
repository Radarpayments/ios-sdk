//
//  String+Extensions.swift
//  SDKCore
//
// 
//

import Foundation
import UIKit

public extension String {
    
    func digitsOnly(maxLength: Int? = nil) -> String {
        let digits = replacingOccurrences(of: "[^\\d.]",
                                          with: "",
                                          options: .regularExpression)
        if let maxLength = maxLength {
            return String(digits.prefix(maxLength))
        }
        return digits
    }
    
    func take(_ count: Int) -> String {
        return String(self.prefix(count))
    }
    
    func takeLast(_ count: Int) -> String {
        return String(self.suffix(count))
    }
    
    func toIntOrNil() -> Int? {
        return Int(self)
    }
    
    func toRegex(options: NSRegularExpression.Options = []) -> NSRegularExpression {
        return try! NSRegularExpression(pattern: self, options: options)
    }
    
    func pemKeyContent() -> String {
        return replacingOccurrences(of: "\\s+", with: "")
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "-----BEGIN PUBLIC KEY-----", with: "")
            .replacingOccurrences(of: "-----END PUBLIC KEY-----", with: "")
            .replacingOccurrences(of: "-----BEGIN CERTIFICATE-----", with: "")
            .replacingOccurrences(of: "-----END CERTIFICATE-----", with: "")
    }

    func toExpDate() throws -> ExpiryDate {
        let pattern = try NSRegularExpression(
            pattern: "^\\d{2}/\\d{2}$",
            options: .caseInsensitive
        )
        let matches = pattern.matches(
            in: self,
            options: [],
            range: NSRange(
                location: 0,
                length: count
            )
        )
        if matches.count == 0 {
            throw NSError(domain: "Incorrect format, should be MM/YY.", code: -1, userInfo: nil)
        }
        let expMonthString = String(prefix(2))
        let expYearString = String(suffix(2))
        guard let expMonth = Int(expMonthString), let expYear = Int(expYearString) else {
            throw NSError(domain: "Invalid month or year", code: -1, userInfo: nil)
        }
        return ExpiryDate(expYear: expYear + 2000, expMonth: expMonth)
    }

    func parseColor() -> UIColor? {
        let hexString: String
        if count == 4 {
            let startIndex = index(after: startIndex)
            let endIndex = index(before: endIndex)
            hexString = "#\(self[startIndex])\(self[startIndex])\(self[endIndex])\(self[endIndex])\(self[endIndex])\(self[endIndex])"
        } else {
            hexString = self
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }

    func noSpaces(maxLength: Int? = nil) -> String {
        let noSpaces = replacingOccurrences(of: "[\\s.]",
                                            with: "",
                                            options: .regularExpression)
        if let maxLength = maxLength {
            return String(noSpaces.prefix(maxLength))
        }
        return noSpaces
    }
}
