//
//  CellConfig.swift
//  SampleApp
//
//
//

import Foundation

struct CellConfig {
    
    var placeholder: String
    var value: String
    
    mutating func setValue(_ value: String) {
        self.value = value
    }
}
