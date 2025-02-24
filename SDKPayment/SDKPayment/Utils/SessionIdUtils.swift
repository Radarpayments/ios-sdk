//
//  File.swift
//

import Foundation
import SDKCore

final class SessionIdUtils {
    
    func extractValue(from id: String) -> String? {
        guard let encodedValue = encodedValue(for: id),
              let decodedValue = Base58.decode(encodedValue),
              let convertedValue = String(bytes: decodedValue, encoding: .utf8)
        else { return nil }

        return processDecodedValue(convertedValue)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func encodedValue(for id: String) -> String? {
        guard id.hasPrefix("ps_"), id.count > 3 else { return nil }
        
        let stringIndex = id.index(id.startIndex, offsetBy: 3)
        return String(id.suffix(from: stringIndex))
    }

    private func processDecodedValue(_ id: String) -> String? {
        guard id.hasPrefix("ps:"), id.count > 3 else { return nil }
        
        let stringIndex = id.index(id.startIndex, offsetBy: 3)
        return String(id.suffix(from: stringIndex))
    }
}
