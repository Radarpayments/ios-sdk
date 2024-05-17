//
//  Use3DSConfig.swift
//  SDKPayment
//
//
//

import Foundation

public enum Use3DSConfig: Codable {
    case noUse3ds2sdk
    case use3ds2sdk(dsRoot: String)
}
