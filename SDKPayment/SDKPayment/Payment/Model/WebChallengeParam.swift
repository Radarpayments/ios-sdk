//
//  WebChallengeParam.swift
//  SDKPayment
//
// 
//

import Foundation

/// Web Challenge params class .
///
/// - Parameters:
///     - mdOrder order number.
///     - acsUrl automatic configuration server url.
///     - paReq params request.
///     - termUrl terminal url.
struct WebChallengeParam {

    let mdOrder: String
    let acsUrl: String
    let paReq: String
    let termUrl: String
}
