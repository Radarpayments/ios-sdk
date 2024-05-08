//
//  CardInfo.swift
//  SDKForms
//
// 
//

import Foundation

/// Card style and type information.
///
/// - Parameters:
///     - backgroundColor: background color.
///     - backgroundGradient: gradient colors background.
///     - backgroundLightness: true if the background is light colors, otherwise false.
///     - textColor: the color of the text on the card, in the format #ffffff or #fff.
///     - logoMini: link to the card bank logo file.
///     - paymentSystem: payment system name.
///     - status: response answer.
public struct FormsCardInfo: Codable {
    
    let backgroundColor: String
    let backgroundGradient: [String]
    let backgroundLightness: Bool
    let textColor: String
    var logoMini: String
    let paymentSystem: String
    let status: String
}
