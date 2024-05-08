//
//  String+Extensions.swift
//  SDKPayment
//
// 
//

import Foundation

extension String {
    
    func containsAnyOfKeywordIgnoreCase(keywords: [String]) -> Bool {
        for keyword in keywords {
            if self.lowercased()
                .contains(keyword.lowercased()) {
                return true
            }
        }
        return false
    }
}
