//
//  TextField3DS2Example.swift
//  SampleApp
//
//  Created by Alex Korotkov on 27.09.2021.
//  Copyright © 2021 AnjLab. All rights reserved.
//

import Foundation
import CardKit

class TextField3DS2Example: UITextField {
  override init(frame: CGRect) {
    super.init(frame: frame)
    _setup()
    _addDoneButtonOnKeyboard()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    _setup()
    _addDoneButtonOnKeyboard()
  }
  
  func _setup(){
    self.backgroundColor = CardKConfig.shared.theme.colorCellBackground
    if #available(iOS 13.0, *) {
      self.backgroundColor = .systemGray5
    }

    self.layer.cornerRadius = 10
    self.leftViewMode = .always
    self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    self.clearButtonMode = .always
  }
  
  func _addDoneButtonOnKeyboard(){
    let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
    doneToolbar.barStyle = .default

    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.resignFirstResponder))

    let items = [flexSpace, done]
    doneToolbar.items = items
    doneToolbar.sizeToFit()

    self.inputAccessoryView = doneToolbar
  }
}
