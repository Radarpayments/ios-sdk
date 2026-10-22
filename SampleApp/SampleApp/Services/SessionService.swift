//
//  SessionService.swift
//  MyStore
//

import Foundation
import SDKPayment

final class SessionService {

    static func registerNewSession(
        requestUrl: String,
        apiKey: String,
        apiVersion: String,
        successUrl: String,
        failureUrl: String,
        amount: String,
        currency: String,
        merchantCustomerId: String,
        completionHandler: @escaping (_ sessionId: String) -> Void
    ) {
        let headers = [
            "Content-Type": "application/json",
            "X-Version": apiVersion,
            "X-Api-Key": apiKey
        ]

        let body: [String: Any] = [
            "amount": Int(amount) ?? 100,
            "currency": currency,
            "successUrl": successUrl,
            "failureUrl": failureUrl,
            "merchantCustomerId": merchantCustomerId
        ]

        var request = URLRequest(url: NSURL(string: "\(requestUrl)")! as URL)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.timeoutInterval = 30.0

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data,
                  let responseParams = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            else { return }

            completionHandler(responseParams["id"] as? String ?? "")
        }.resume()
    }
}
