//
//  CellDelegate.swift
//  SampleApp
//
//
//

import Foundation

protocol CellDelegate: AnyObject {
    
    func valueDidChange(id: String, value: String)
}
