//
//  Utils.swift
//  SampleApp
//
//  Created by Alex Korotkov on 1/21/21.
//  Copyright © 2021 AnjLab. All rights reserved.
//

import Foundation

class Utils {
  static func jsonSerialization(data: [String: String]) -> String {
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: data, options: [.prettyPrinted])
      return String(data: jsonData, encoding: .utf8)!
    } catch {
      return "Error JSONSerialization"
    }
  }
  
  static func jsonSerialization(data: Data) -> String {
    do {
      let json = try JSONSerialization.jsonObject(with: data, options: [])
      let dataWithPretty = try JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])
      return String(data: dataWithPretty, encoding: .utf8)!
    } catch {
      return "Error JSONSerialization"
    }
  }
}
