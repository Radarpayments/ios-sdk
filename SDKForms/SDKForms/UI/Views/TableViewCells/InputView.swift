//
//  InputView.swift
//

import Foundation

protocol InputView {
    
    var isFilled: Bool { get }
    var value: String { get }
    
    func setActive(_ active: Bool)
    func setFilled(_ filled: Bool)
}
