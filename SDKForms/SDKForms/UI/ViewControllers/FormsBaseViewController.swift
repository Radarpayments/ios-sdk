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
    
    override public func viewDidDisappear(_ animated: Bool) {
        if !actionWasCalled {
            callbackHandler?.onFail(error: SDKException())
        }
        
        super.viewDidDisappear(animated)
    }
}
