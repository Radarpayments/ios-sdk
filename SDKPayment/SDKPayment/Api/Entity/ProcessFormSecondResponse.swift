//
//  ProcessFormSecondResponse.swift
//  SDKPayment
//
// 
//

import Foundation

///Response DTO for requesting payment by new card with 3ds.
///
/// - Parameters:
///     - errorCode error code.
///     - is3DSVer2 there is 3DS.
///     - redirect success url
///     - info info about process of payment
///     - threeDSAcsTransactionId transaction identifier into ACS.
///     - threeDSAcsRefNumber identifier ACS.
///     - threeDSAcsSignedContent sign content for ACS.
///     - threeDSDsTransID
///     - error error description
///     - errorTypeName description of error type
///     - displayErrorMessage description of error for displaying
///     - processingErrorType description of type error processing
///     - errorMessage description of error
struct ProcessFormSecondResponse: Codable {

    let errorCode: Int
    var is3DSVer2: Bool = false

    let redirect: String?
    let info: String?
    
    let threeDSAcsTransactionId: String?
    let threeDSAcsRefNumber: String?
    let threeDSAcsSignedContent: String?
    let threeDSDsTransID: String?
    
    let error: String?
    let errorTypeName: String?
    let displayErrorMessage: String?
    let processingErrorType: String?
    let errorMessage: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.errorCode = try container.decode(Int.self, forKey: .errorCode)
        self.is3DSVer2 = (try? container.decode(Bool.self, forKey: .is3DSVer2)) ?? false
        
        self.redirect = try? container.decodeIfPresent(String.self, forKey: .redirect)
        self.info = try? container.decodeIfPresent(String.self, forKey: .info)

        self.threeDSAcsTransactionId = try? container.decodeIfPresent(String.self, forKey: .threeDSAcsTransactionId)
        self.threeDSAcsRefNumber = try? container.decodeIfPresent(String.self, forKey: .threeDSAcsRefNumber)
        self.threeDSAcsSignedContent = try? container.decodeIfPresent(String.self, forKey: .threeDSAcsSignedContent)
        self.threeDSDsTransID = try? container.decodeIfPresent(String.self, forKey: .threeDSDsTransID)
        
        self.error = try? container.decodeIfPresent(String.self, forKey: .error)
        self.errorTypeName = try? container.decodeIfPresent(String.self, forKey: .errorTypeName)
        self.displayErrorMessage = try? container.decodeIfPresent(String.self, forKey: .displayErrorMessage)
        self.processingErrorType = try? container.decodeIfPresent(String.self, forKey: .processingErrorType)
        self.errorMessage = try? container.decodeIfPresent(String.self, forKey: .errorMessage)
    }
}
