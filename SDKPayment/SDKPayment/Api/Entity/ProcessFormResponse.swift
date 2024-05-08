//
//  ProcessFormResponse.swift
//  SDKPayment
//
// 
//

import Foundation

/// Response DTO for requesting payment by new card.
///
/// - Parameters:
///     - errorCode error code.
///     - is3DSVer2 there is 3DS.
///     - threeDSServerTransId transaction identifier for 3DS Server.
///     - threeDSSDKKey key to encrypt device data.
///     - acsUrl automatic configuration server url.
///     - paReq params request.
///     - termUrl terminal url.
///     - threeDSMethodURL if not null, then merchant doesn't have 3ds configured.
struct ProcessFormResponse: Codable {

    let errorCode: Int
    var is3DSVer2: Bool = false
    let threeDSServerTransId: String?
    let threeDSSDKKey: String?
    let acsUrl: String?
    let paReq: String?
    let termUrl: String?
    let threeDSMethodURL: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.errorCode = try container.decode(Int.self, forKey: .errorCode)
        self.is3DSVer2 = (try? container.decode(Bool.self, forKey: .is3DSVer2)) ?? false
        self.threeDSServerTransId = try? container.decodeIfPresent(String.self, forKey: .threeDSServerTransId)
        self.threeDSSDKKey = try? container.decodeIfPresent(String.self, forKey: .threeDSSDKKey)
        self.acsUrl = try? container.decodeIfPresent(String.self, forKey: .acsUrl)
        self.paReq = try? container.decodeIfPresent(String.self, forKey: .paReq)
        self.termUrl = try? container.decodeIfPresent(String.self, forKey: .termUrl)
        self.threeDSMethodURL = try? container.decodeIfPresent(String.self, forKey: .threeDSMethodURL)
    }
}
