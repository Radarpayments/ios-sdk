//
//  File.swift
//

import Foundation
import SDKForms

struct PaymentResultData {
    
    var isSuccess = false
    let exception: SDKException?
    
    init(isSuccess: Bool = false, 
         exception: SDKException? = nil) {
        self.isSuccess = isSuccess
        self.exception = exception
    }
}
