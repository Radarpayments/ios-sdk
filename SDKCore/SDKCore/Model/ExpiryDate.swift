//
//  ExpiryDate.swift
//  SDKCore
//
// 
//

import Foundation

/// Struct for expiry date card.
///
/// - Parameters:
///     - expYear:year in format  yyyy.
///     - expMonth: month in format  mm.
public struct ExpiryDate: Codable, Hashable, Equatable {

    public let expYear: Int
    public let expMonth: Int
    
    public func formatExpiryDate() -> String {
        return "\(self.expMonth)/\(self.expYear % 100)"
    }
    
    public func format() -> String {
        "\(expYear)\(expMonth)"
    }
    
    public init(expYear: Int, expMonth: Int) {
        self.expYear = expYear
        self.expMonth = expMonth
    }
}
