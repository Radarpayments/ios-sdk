//
//  UnbindCardResponse.swift
//  SDKPayment
//
// 
//

import Foundation

/// Response DTO for unbind card method.
/// If errorCode equals [SUCCESS_ERROR_CODE] then the card was unbind.
///
/// - Parameters:
///     - errorCode error code.
struct UnbindCardResponse: Codable {
    
    private let succesErrorCode = 0
    var errorCode: Int
    
    var isSuccess: Bool { errorCode == succesErrorCode }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.errorCode = try container.decode(Int.self, forKey: .errorCode)
    }
}
