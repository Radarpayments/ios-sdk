//
//  File.swift
//

import Foundation
import SDKCore
import SDKForms

final class MandatoryFieldsDefaultProvider: MandatoryFieldsProvider {
    
    private let paymentSystems: [String: String] = [
        "^(5[1-5]|222[1-9]|2[3-6]|27[0-1]|2720)\\d*$": "MASTERCARD",
        "^4\\d*$": "VISA"
    ]
    
    private let sessionStatus: SessionStatusResponse
    private var mandatoryItems = [MandatoryItem]()
    
    init(sessionStatus: SessionStatusResponse) {
        self.sessionStatus = sessionStatus
    }
    
    func resolveFields(forCardNumber number: String) -> [MandatoryItem] {
        if number.isEmpty { return [] }

        let cardNumberValidator = CardNumberValidator()
        let validationResult = cardNumberValidator.validate(data: number.digitsOnly())
        
        if let resolvedPaymentSystem = resolvePaymentSystem(for: number.digitsOnly()),
            validationResult.isValid {
            return resolveFields(forPaymentSystem: resolvedPaymentSystem)
        }
        
        return []
    }
    
    func resolveFields(forPaymentSystem system: String) -> [MandatoryItem] {
        var mandatoryItems = [MandatoryItem]()
        
        if let targetPaymentSystem = PaymentSystem.allCases
            .first(where: { $0.rawValue == system }) {

            switch targetPaymentSystem {
            case .visa:
                mandatoryItems.append(contentsOf: prepareMandatoryItems(for: targetPaymentSystem))
                
            case .masterCard:
                mandatoryItems.append(contentsOf: prepareMandatoryItems(for: targetPaymentSystem))

            default:
                break
            }
        }
        self.mandatoryItems = mandatoryItems
        
        return mandatoryItems
    }
    
    func validateFieldValue(fieldId: String, _ value: String) -> ValidationResult? {
        guard let payerDataField = BillingPayerDataFields(stringValue: fieldId) else { return nil }
        
        switch payerDataField {
        case .BILLING_COUNTRY:
            if let mandatoryField = mandatoryField(forId: fieldId),
               mandatoryField.isRequired {
                
            }
            return CountryValidator().validate(data: value)
        case .BILLING_STATE:
            return StateValidator().validate(data: value)
        case .BILLING_CITY:
            return CityValidator().validate(data: value)
        case .BILLING_POSTAL_CODE:
            return PostalCodeValidator().validate(data: value)
        case .BILLING_ADDRESS_LINE1:
            return AddressLine1Validator().validate(data: value)
        case .BILLING_ADDRESS_LINE2:
            return AddressLine2Validator().validate(data: value)
        case .BILLING_ADDRESS_LINE3:
            return AddressLine3Validator().validate(data: value)
        case .EMAIL:
            return EmailValidator().validate(data: value)
        case .MOBILE_PHONE:
            return PhoneNumberValidator().validate(data: value)
        }
    }
    
    func mandatoryField(forId id: String) -> MandatorySingleField? {
        if let mandatoryItem = mandatoryItem(items: self.mandatoryItems, withFieldId: id) {
            switch mandatoryItem {
            case let .singleField(field):
                return field
                
            case .twoFields(let fields):
                if fields.leadingField?.id == id {
                    return fields.leadingField
                }
                if fields.trailingField?.id == id {
                    return fields.trailingField
                }
                
                return nil
            }
        }
        
        return nil
    }
    
    func validateFieldsValues(fieldValues: [String: String]) -> [String: ValidationResult] {
        var validationsResult = [String: ValidationResult]()
        var mandatoryFields = [MandatorySingleField]()
        
        mandatoryItems.forEach { mandatoryItem in
            switch mandatoryItem {
            case let .singleField(field):
                mandatoryFields.append(field)
            case let .twoFields(fields):
                if let leadingField = fields.leadingField {
                    mandatoryFields.append(leadingField)
                }
                
                if let trailingField = fields.trailingField {
                    mandatoryFields.append(trailingField)
                }
            }
        }
        
        
        mandatoryFields.forEach { field in
            if field.isRequired {
                validationsResult[field.id] = validateFieldValue(
                    fieldId: field.id,
                    fieldValues[field.id] ?? ""
                )
            } else {
                validationsResult[field.id] = .VALID
            }
        }
        
        return validationsResult
    }
    
    private func resolvePaymentSystem(for value: String) -> String? {
        let acceptedSystem = paymentSystems.keys
            .filter {
                let range = NSRange(location: 0, length: value.count)
                let regex = try? NSRegularExpression(pattern: $0)
                return !(regex?.matches(in: value, range: range).isEmpty ?? true)
            }
            .first
        
        if let acceptedSystem, let paymentSystem = paymentSystems[acceptedSystem] {
            return paymentSystem
        }
        
        return nil
    }
    
    private func resolveBillingFields(for paymentSystem: PaymentSystem) -> [MandatorySingleField] {
        guard let targetParams = sessionStatus.payerDataParamsNeedToBeFilled[paymentSystem.rawValue] else { return [] }
        
        var mandatoryFields = [MandatorySingleField]()
        
        BillingPayerDataFields.allCases.forEach { billingPayerDataField in
            if let targetParam = targetParams.first(where: { $0.name == billingPayerDataField.rawValue }) {
                let placeholder = placeholder(for: billingPayerDataField)
                var preFilledValue: String? = nil
                
                switch billingPayerDataField {
                case .EMAIL:
                    preFilledValue = sessionStatus.customerDetails?.email
                case .MOBILE_PHONE:
                    preFilledValue = sessionStatus.orderPayerData?.mobilePhone ?? sessionStatus.customerDetails?.phone
                case .BILLING_COUNTRY,
                        .BILLING_STATE,
                        .BILLING_CITY,
                        .BILLING_POSTAL_CODE,
                        .BILLING_ADDRESS_LINE1,
                        .BILLING_ADDRESS_LINE2,
                        .BILLING_ADDRESS_LINE3:
                    if let billingPayerData = sessionStatus.billingPayerData {
                        let helper = BillingPayerDataHelper(payerData: billingPayerData)
                        preFilledValue = helper.value(for: billingPayerDataField)
                    }
                }
                
                mandatoryFields.append(
                    MandatorySingleField(
                        id: billingPayerDataField.rawValue,
                        placeholder: placeholder,
                        preFilledValue: preFilledValue,
                        isRequired: targetParam.mandatory
                    )
                )
            }
        }
        
        return mandatoryFields
    }
    
    private func mandatoryItem(items: [MandatoryItem], withFieldId fieldId: String) -> MandatoryItem? {
        if let mandatoryItem = items.first(where: { mandatoryItem in
            switch mandatoryItem {
            case let .singleField(field):
                if field.id == fieldId { return true }
                return false
                
            case let .twoFields(fields):
                if fields.leadingField?.id == fieldId { return true }
                if fields.trailingField?.id == fieldId { return true }
                return false
            }
        }) {
            return mandatoryItem
        }
        
        return nil
    }
    
    private func prepareMandatoryItems(for paymentSystem: PaymentSystem) -> [MandatoryItem] {
        let mandatoryFields = resolveBillingFields(for: paymentSystem)
        var mandatoryItems = [MandatoryItem]()
        
        BillingPayerDataFields.allCases.forEach { billingPayerDataField in
            if let mandatoryField = mandatoryFields.first(where: { $0.id == billingPayerDataField.rawValue }) {
                switch billingPayerDataField {
                case .MOBILE_PHONE,
                        .EMAIL,
                        .BILLING_ADDRESS_LINE1,
                        .BILLING_ADDRESS_LINE2,
                        .BILLING_ADDRESS_LINE3:
                    mandatoryItems.append(.singleField(field: mandatoryField))

                case .BILLING_COUNTRY:
                    if let mandatoryItem = mandatoryItem(items: mandatoryItems, withFieldId: BillingPayerDataFields.BILLING_STATE.rawValue) {
                        if case let .twoFields(fields) = mandatoryItem {
                            fields.leadingField = mandatoryField
                        }
                    } else {
                        mandatoryItems.append(
                            .twoFields(
                                fields: MandatoryTwoFields(
                                    leadingField: mandatoryField
                                )
                            )
                        )
                    }

                case .BILLING_STATE:
                    if let mandatoryItem = mandatoryItem(items: mandatoryItems, withFieldId: BillingPayerDataFields.BILLING_COUNTRY.rawValue) {
                        if case let .twoFields(fields) = mandatoryItem {
                            fields.trailingField = mandatoryField
                        }
                    } else {
                        mandatoryItems.append(
                            .twoFields(
                                fields: MandatoryTwoFields(
                                    trailingField: mandatoryField
                                )
                            )
                        )
                    }
                    
                case .BILLING_CITY:
                    if let mandatoryItem = mandatoryItem(items: mandatoryItems, withFieldId: BillingPayerDataFields.BILLING_POSTAL_CODE.rawValue) {
                        if case let .twoFields(fields) = mandatoryItem {
                            fields.trailingField = mandatoryField
                        }
                    } else {
                        mandatoryItems.append(
                            .twoFields(
                                fields: MandatoryTwoFields(
                                    trailingField: mandatoryField
                                )
                            )
                        )
                    }

                case .BILLING_POSTAL_CODE:
                    if let mandatoryItem = mandatoryItem(items: mandatoryItems, withFieldId: BillingPayerDataFields.BILLING_CITY.rawValue) {
                        if case let .twoFields(fields) = mandatoryItem {
                            fields.leadingField = mandatoryField
                        }
                    } else {
                        mandatoryItems.append(
                            .twoFields(
                                fields: MandatoryTwoFields(
                                    leadingField: mandatoryField
                                )
                            )
                        )
                    }
                }
            }
        }
        
        return mandatoryItems
    }
    
    private func placeholder(for field: BillingPayerDataFields) -> String {
        switch field {
        case .BILLING_COUNTRY:       .country()
        case .BILLING_STATE:         .state()
        case .BILLING_CITY:          .city()
        case .BILLING_POSTAL_CODE:   .postalCode()
        case .BILLING_ADDRESS_LINE1: .addressLine1()
        case .BILLING_ADDRESS_LINE2: .addressLine2()
        case .BILLING_ADDRESS_LINE3: .addressLine3()
        case .EMAIL:                 .email()
        case .MOBILE_PHONE:          .phoneNumber()
        }
    }
    
    func textPattern(forFieldId id: String) -> CardDataTextFieldStringPattern {
        if let billingPayerDataField = BillingPayerDataFields(stringValue: id) {
            switch billingPayerDataField {
            case .BILLING_COUNTRY,
                 .BILLING_STATE,
                 .BILLING_CITY,
                 .BILLING_POSTAL_CODE,
                 .BILLING_ADDRESS_LINE1,
                 .BILLING_ADDRESS_LINE2,
                 .BILLING_ADDRESS_LINE3:
                return .mandatoryField
            case .EMAIL:
                return .email
            case .MOBILE_PHONE:
                return .phoneNumber
            }
        }
        
        return .plain
    }
}
