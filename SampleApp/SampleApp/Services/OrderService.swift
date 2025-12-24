//
//  OrderService.swift
//  MyStore
//

import Foundation
import SDKPayment

final class OrderService {

    static func registerNewOrder(
        requestUrl: String,
        userName: String,
        password: String,
        returnUrl: String,
        amount: String,
        clientId: String,
        orderId: String,
        completionHandler: @escaping (_ orderId: String) -> Void
    ) {
        let headers = [
            "content-type": "application/x-www-form-urlencoded"
        ]

        let body = [
            "amount": amount,
            "userName": userName,
            "password": password,
            "returnUrl": returnUrl,
            "clientId": clientId,
            "orderNumber": orderId,
        ]

        var request = URLRequest(url: NSURL(string: "\(requestUrl)")! as URL)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.timeoutInterval = 30.0
        request.encodeParameters(parameters: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data,
                  let responseParams = try? JSONDecoder().decode([String: String].self, from: data)
            else { return }

            completionHandler(responseParams["orderId"] ?? "")
        }.resume()
    }
}

extension URLRequest {
    private func percentEscapeString(_ string: String) -> String {
        var characterSet = CharacterSet.alphanumerics

        characterSet.insert(charactersIn: "-._* ")

        return string
            .addingPercentEncoding(withAllowedCharacters: characterSet)!
            .replacingOccurrences(of: " ", with: "+")
            .replacingOccurrences(of: " ", with: "+", options: [], range: nil)
    }

    mutating func encodeParameters(parameters: [String : String]) {
        httpMethod = "POST"

        let parameterArray = parameters.map { (arg) -> String in
            let (key, value) = arg

            return "\(key)=\(self.percentEscapeString(value))"
        }

        httpBody = parameterArray.joined(separator: "&").data(using: .utf8)
    }
}
