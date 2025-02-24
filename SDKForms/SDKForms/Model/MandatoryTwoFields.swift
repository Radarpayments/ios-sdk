//
//  File.swift
//  

import Foundation

public class MandatoryTwoFields {
    
    public var leadingField: MandatorySingleField?
    public var trailingField: MandatorySingleField?
    
    public init(leadingField: MandatorySingleField? = nil,
                trailingField: MandatorySingleField? = nil) {
        self.leadingField = leadingField
        self.trailingField = trailingField
    }
}
