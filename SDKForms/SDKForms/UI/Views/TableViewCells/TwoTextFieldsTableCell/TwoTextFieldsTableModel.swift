//
//  TwoTextFieldsTableModel.swift
//
//
// 
//

import Foundation

struct TwoTextFieldsTableModel: Hashable {
    
    let id: String
    let cardExpiryViewConfig: CardDataTextFieldViewState
    let cardCVCViewConfig: CardDataTextFieldViewState
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension TwoTextFieldsTableModel: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
