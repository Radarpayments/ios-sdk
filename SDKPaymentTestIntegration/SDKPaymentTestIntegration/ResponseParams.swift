//
//  ResponseParams.swift
//  SDKPaymentIntegration
//
//
//

import Foundation

struct ResponseParams: Codable {
  var orderId: String?
  var threeDSServerTransId: String?
  var threeDSSDKKey: String?
  
  var acsTransID: String?
  var acsReferenceNumber: String?
  var acsSignedContent: String?
  
  enum CodingKeys: String, CodingKey {
    case orderId = "orderId"
    case threeDSServerTransId = "threeDSServerTransId"
    case threeDSSDKKey = "threeDSSDKKey"
    case acsTransID = "threeDSAcsTransactionId"
    case acsReferenceNumber = "threeDSAcsRefNumber"
    case acsSignedContent = "threeDSAcsSignedContent"
  }
}
