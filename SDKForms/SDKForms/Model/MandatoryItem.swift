//
//  File.swift
//  

import Foundation

public enum MandatoryItem {
    
    case singleField(field: MandatorySingleField)
    case twoFields(fields: MandatoryTwoFields)
}
