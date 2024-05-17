//
//  MSDKRegisteredFrom.swift
//  SDKCore
//
//
//

import Foundation

public enum MSDKRegisteredFrom: String, RawRepresentable, Codable, Equatable {
    case MSDK_CORE = "MSDK_CORE"
    case MSDK_FORMS = "MSDK_FORMS"
    case MSDK_PAYMENT = "MSDK_PAYMENT"
}
