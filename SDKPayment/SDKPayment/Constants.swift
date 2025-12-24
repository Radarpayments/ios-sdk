//
//  Constants.swift
//  SDKPayment
//
//
//

import Foundation

struct Constants {
    // SDK Version
    static let SDK_VERSION = "3.0.10"

    // Tag for the log SDK Payment processes
    static let TAG = "SDK Payment"
    // Tag for the log SDK Payment UI processes
    static let TAG_UI = "SDK Payment UI"

    // Timeout interval for requests
    static let TIMEOUT_INTERVAL_REQUEST: TimeInterval = 30.0
    // Timeout interval for resources
    static let TIMEOUT_INTERVAL_RESOURCE: TimeInterval = 60.0
    // Maximum connections per host
    static let HTTP_MAX_CONNECTIONS_PER_HOST: Int = 4

    static let URL_CARD_INFO_BIN = "https://mrbin.io/bins/"
    static let URL_CARD_INFO_BIN_DISPLAY = "https://mrbin.io/bins/display"
}
