//
//  TwoTextFieldsTableModel.swift
//
//
// 
//

import Foundation

protocol TwoTextFieldsTableModelProtocol: Hashable {
    
    var id: String { get }
    
    var leadingTextFieldViewConfig: CardDataTextFieldViewState? { get }
    var trailingTextFieldViewConfig: CardDataTextFieldViewState? { get }
}

struct TwoTextFieldsTableModel: TwoTextFieldsTableModelProtocol {
    
    let id: String
    let leadingTextFieldViewConfig: CardDataTextFieldViewState?
    let trailingTextFieldViewConfig: CardDataTextFieldViewState?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension TwoTextFieldsTableModel: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
