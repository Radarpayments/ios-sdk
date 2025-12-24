//
//  MSDKRegisteredFrom.swift
//  SDKCore
//
//
//

import Foundation

public enum MSDKRegisteredFrom: String, RawRepresentable, Codable, Equatable {
    case MSDK_CORE = "MSDK_CORE"
    case MSDK_PAYMENT = "MSDK_PAYMENT"
    case MSDK_PAYMENT_UI = "MSDK_PAYMENT_UI"
}
