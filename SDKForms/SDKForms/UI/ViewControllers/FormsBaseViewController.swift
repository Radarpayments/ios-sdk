//
//  FormsBaseViewController.swift
//  SDKForms
//
// 
//

import UIKit

public class FormsBaseViewController: UIViewController {
    
    var actionWasCalled = false
    var callbackHandler: (any ResultCryptogramCallback<CryptogramData>)?
    
    override public func loadView() {
        super.loadView()
        
        observeKeyboard()
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        if !actionWasCalled {
            callbackHandler?.onFail(error: SDKException())
        }
        removeKeyboardObservers()

        super.viewDidDisappear(animated)
    }
    
    func handleKeyboardChanging(keyboardFrame: CGRect) {}
    
    private func observeKeyboard() {
        _ = NotificationCenter.default
            .addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main, using: { [weak self] notification in
                guard let self,
                      let userInfo = notification.userInfo,
                      let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
                else { return }
                handleKeyboardChanging(keyboardFrame: keyboardFrame)
            })

        _ = NotificationCenter.default
            .addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main, using: { [weak self] notification in
                guard let self else { return }
                
                handleKeyboardChanging(keyboardFrame: CGRect.zero)
            })
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self)
    }
}
