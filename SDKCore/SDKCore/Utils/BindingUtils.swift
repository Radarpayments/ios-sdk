//
//  File.swift
//  

import Foundation

/// Class for extracting value from the storedPaymentMewthodId
final class BindingUtils {
    
    func extractValue(from id: String) -> String {
        let encodedValue = encodedValue(for: id)
        
        guard let decodedValue = Base58.decode(encodedValue),
              let convertedValue = String(bytes: decodedValue, encoding: .utf8)
        else { return String() }
        
        return convertedValue
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func encodedValue(for id: String) -> String {
        guard id.hasPrefix("pm_"), id.count > 3 else { return String() }
        
        let stringIndex = id.index(id.startIndex, offsetBy: 3)
        return String(id.suffix(from: stringIndex))
    }
}
