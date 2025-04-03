//
//  OrderCreator.swift
//  SampleApp
//
//
//

import Foundation
import SDKPayment

final class OrderCreator {
    
    static func registerNewOrder(baseUrl: String,
                                 amount: String,
                                 userName: String,
                                 password: String,
                                 completionHandler: @escaping (_ orderId: String) -> Void) {
        let headers = ["content-type": "application/x-www-form-urlencoded"]
        
        let body = [
            "amount": amount,
            "userName": userName,
            "password": password,
            "returnUrl": "sdk://done",
            "clientId": "ClientIdTestIOS",
            "orderNumber": "\(Int64.random(in: Int64.min...Int64.max))",
        ]

        
        var request = URLRequest(url: NSURL(string: "\(baseUrl)/rest/register.do")! as URL)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.encodeParameters(parameters: body)
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data,
                  let responseParams = try? JSONDecoder().decode([String: String].self, from: data)
            else { return }
            
            completionHandler(responseParams["orderId"] ?? "")
        }.resume()
    }
    
    static func registerNewSession(baseUrl: String,
                                   amount: String,
                                   completionHandler: @escaping (_ sessionId: String) -> Void) {
        let headers = ["Content-Type": "application/json",
                       "X-Version": "2023-10-31",
                       "X-Api-Key": "9yVrffWNAiHUUVUCQoX4NFHMxmRHYA2yB"]
        
        let body: [String: Any] = ["amount": 2000,
                    "currency": "USD",
                    "successUrl": "sdk://done",
                    "failureUrl": "sdk://failure"]
        
        var request = URLRequest(url: NSURL(string: "https://dev.bpcbt.com/api2/sessions")! as URL)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data,
                  let responseParams = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            else { return }
            
            completionHandler(responseParams["id"] as? String ?? "")
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
