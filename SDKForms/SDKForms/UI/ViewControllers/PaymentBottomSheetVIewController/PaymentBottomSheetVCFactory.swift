//
//  PaymentBottomSheetVCFactory.swift
//  SDKForms
//
// 
//

import UIKit

final class PaymentBottomSheetVCFactory: NSObject {
    
    private var tableView: UITableView?
    private var sections = [PaymentBottomSheetVCSection]()
    private weak var owner: (FormsBaseViewController & CardListSelectable)?
    
    func setTableView(tableView: UITableView) {
        self.tableView = tableView
        
        setupTableView()
        registerCells()
    }
    
    
    func setOwner(_ owner: FormsBaseViewController & CardListSelectable) {
        self.owner = owner
    }
    
    func updateSections(sections: [PaymentBottomSheetVCSection]) {
        self.sections = sections
        tableView?.reloadData()
    }
    
    private func setupTableView() {
        tableView?.separatorStyle = .none
    }
    
    private func registerCells() {
        tableView?.registerClass(ApplePayTableCell.self)
        tableView?.registerClass(BindingCardTableCell.self)
        tableView?.registerClass(AddNewCardTableCell.self)
        tableView?.registerClass(PaymentsMethodsTableCell.self)
        
        tableView?.registerReusableView(DividerTableHeader.self)
    }
    
    private func cell(for indexPath: IndexPath) -> UITableViewCell? {
        let itemModel = sections[indexPath.section].items[indexPath.row]
        
        switch itemModel {
        case let itemModel as ApplePayTableModel:
            let cell = tableView?.dequeueReusableCell(ApplePayTableCell.self, for: indexPath) as? ApplePayTableCell
            
            return cell?.bind(
                model: itemModel,
                delegate: owner as? ApplePayTableCellDelegate
            )
            
        case let itemModel as BindingCardTableModel:
            let cell = tableView?.dequeueReusableCell(BindingCardTableCell.self, for: indexPath) as? BindingCardTableCell
            
            return cell?.bind(model: itemModel)

        case let itemModel as AddNewCardTableModel:
            let cell = tableView?.dequeueReusableCell(AddNewCardTableCell.self, for: indexPath) as? AddNewCardTableCell
            
            return cell?.bind(model: itemModel)
            
        case let itemModel as PaymentsMethodsTableModel:
            let cell = tableView?.dequeueReusableCell(PaymentsMethodsTableCell.self, for: indexPath) as? PaymentsMethodsTableCell
            
            return cell?.bind(model: itemModel)
            
        default:
            return UITableViewCell()
        }
    }
    
    private func didSelectCell(indexPath: IndexPath) {
        if let cell = tableView?.cellForRow(at: indexPath) {
            switch cell {
            case let cell as AddNewCardTableCell:
                owner?.onClickAddNewCard()
                
            case let cell as BindingCardTableCell:
                if let model = sections[indexPath.section].items[indexPath.row] as? BindingCardTableModel {
                    owner?.onClickCard(withId: model.id)
                }
                
            case let cell as PaymentsMethodsTableCell:
                owner?.onClickAllPayments()
            default:
                break
            }
        }
    }
}

extension PaymentBottomSheetVCFactory: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell(for: indexPath) ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        didSelectCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let targetSection = sections[section]
        
        switch targetSection.header {
        case let itemModel as DividerTableHeaderModel:
            let header = tableView.dequeReusableView(DividerTableHeader.self) as? DividerTableHeader
            return header?.bind(model: itemModel)

        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if let header = sections[section].header { return 44 }
        
        return .zero
    }
}
