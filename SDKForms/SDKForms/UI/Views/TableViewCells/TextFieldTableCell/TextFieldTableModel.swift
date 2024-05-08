//
//  TextFieldTableModel.swift
//  SDKForms
//
// 
//

import Foundation

protocol TextFieldTableModelProtocol: Hashable {
    
    var id: String { get }
    var textFieldViewConfig: CardDataTextFieldViewState { get }
}

struct TextFieldTableModel: TextFieldTableModelProtocol {

    let id: String
    let textFieldViewConfig: CardDataTextFieldViewState
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension TextFieldTableModel: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
