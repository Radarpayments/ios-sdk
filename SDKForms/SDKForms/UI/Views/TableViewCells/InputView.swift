//
//  InputView.swift
//

import Foundation

protocol InputView {
    
    var id: String { get }
    var isFilled: Bool { get }
    var value: String { get }
    
    func setActive(_ active: Bool)
    func setFilled(_ filled: Bool)
}
