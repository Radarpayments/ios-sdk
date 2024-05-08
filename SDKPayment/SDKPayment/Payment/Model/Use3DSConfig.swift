//
//  Use3DSConfig.swift
//  SDKPayment
//
//
//

import Foundation

public enum Use3DSConfig: Codable {
    case use3DS1
    case use3DS2(dsRoot: String)
}
