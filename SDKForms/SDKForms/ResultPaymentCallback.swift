//
//  ResultPaymentCallback.swift
//  SDKForms
//
// 
//

import Foundation

/// An interface for handling the result of an operation that returns [PaymentData] or [Exception].
public protocol ResultPaymentCallback<T>: AnyObject {
    
    associatedtype T
    
    /// Called when the operation is successful, the result of which is [result].
    func onResult(result: T)
}
