//
//  OrderStatuses.swift
//  SDKPayment
//
// 
//

import Foundation

enum OrderStatuses {
    
    static let payedStatuses: [String] = [OrderStatus.deposited.rawValue, OrderStatus.approved.rawValue]
    static let payedCouldNotBeCompleted: [String] = [OrderStatus.declined.rawValue]
}
