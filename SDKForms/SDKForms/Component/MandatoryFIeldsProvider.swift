//
//  File.swift
//

import Foundation
import SDKCore

public protocol MandatoryFieldsProvider {
    
    func resolveFields(forCardNumber number: String) -> [MandatoryItem]
    func resolveFields(forPaymentSystem system: String) -> [MandatoryItem]
    func validateFieldValue(fieldId: String, _ value: String) -> ValidationResult?
    func mandatoryField(forId id: String) -> MandatorySingleField?
    func textPattern(forFieldId id: String) -> CardDataTextFieldStringPattern
    func validateFieldsValues(fieldValues: [String: String]) -> [String: ValidationResult]
}
