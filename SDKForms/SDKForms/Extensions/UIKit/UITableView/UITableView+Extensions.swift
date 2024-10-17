//
//  UITableView+Extensions.swift
//  SDKForms
//
// 
//

import UIKit

extension UITableView {
    
    func registerClass(_ cellClass: UITableViewCell.Type) {
        self.register(cellClass, forCellReuseIdentifier: cellClass.description())
    }
    
    func registerReusableView(_ viewClass: UITableViewHeaderFooterView.Type) {
        self.register(viewClass, forHeaderFooterViewReuseIdentifier: viewClass.description())
    }
    
    func dequeueReusableCell(_ cellClass: UITableViewCell.Type, for indexPath: IndexPath) -> UITableViewCell {
        dequeueReusableCell(withIdentifier: cellClass.description(), for: indexPath)
    }
    
    func dequeReusableView(_ viewClass: UITableViewHeaderFooterView.Type) -> UITableViewHeaderFooterView? {
        dequeueReusableHeaderFooterView(withIdentifier: viewClass.description())
    }
}
