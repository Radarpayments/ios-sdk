//
//  CardHolderTableModel.swift
//  SDKForms
//
// 
//

import Foundation

struct CardHolderTableModel: TextFieldTableModelProtocol {

    let id: String
    let textFieldViewConfig: CardDataTextFieldViewState
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension CardHolderTableModel: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
