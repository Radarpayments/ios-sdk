//
//  ResultCryptogramCallback.swift
//  SDKForms
//
// 
//

import Foundation

/// An interface for handling the result of an operation that returns [CryptogramData] or [Exception].
public protocol ResultCryptogramCallback<T> {
    
    associatedtype T
    
    /// Called when the operation is successful, the result of which is [result].
    func onSuccess(result: T)
    
    /// Called when an error occurs during the execution of an operation. [e] contains a description of the error.
    func onFail(error: SDKException)
}
