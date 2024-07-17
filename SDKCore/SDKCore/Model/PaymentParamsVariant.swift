//
//  File.swift
//  

import Foundation

public enum PaymentParamsVariant {
    
    case cardParams(params: CardParams)
    case cardParamsInstant(params: CardParamsInstant)
    case bindingParams(params: BindingParams)
    case bindingParamsInstant(params: BindingParamsInstant)
    case newPaymentMethodParams(params: NewPaymentMethodParams)
    case storedPaymentMethodParams(params: StoredPaymentMethodParams)
}
