//
//  OrderStatus.swift
//  SDKPayment
//
// 
//

import Foundation

enum OrderStatus: String {
    
    /// Order was created.
    case created
    
    /// Order was payed.
    case deposited
    
    /// Order was payed.
    case approved
    
    /// Order was declined.
    case declined
}
