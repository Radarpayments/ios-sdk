//
//  File.swift
//  

import Foundation

public struct MandatorySingleField {
    
    public let id: String
    public let placeholder: String
    public let preFilledValue: String?
    public var isRequired = false
    
    public init(id: String, 
                placeholder: String,
                preFilledValue: String?,
                isRequired: Bool = false) {
        self.id = id
        self.placeholder = placeholder
        self.preFilledValue = preFilledValue
        self.isRequired = isRequired
    }
}
