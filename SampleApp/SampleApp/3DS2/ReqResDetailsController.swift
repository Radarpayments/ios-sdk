//
//  ReqResDetailsController.swift
//  SampleApp
//
//  Created by Alex Korotkov on 1/15/21.
//  Copyright © 2021 AnjLab. All rights reserved.
//

import UIKit
import ThreeDSSDK

class ReqResDetailsController: UIViewController  {
  let _uiScrollView = UIScrollView()
  let _textView = UITextView()
  let tabs = ["Request", "Response"]
  let _feedback = UINotificationFeedbackGenerator()
  
  var segmentControl: UISegmentedControl = UISegmentedControl()
  var requestInfo = ""
  var responseInfo = ""
  var button = UIBarButtonItem()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()

    segmentControl = UISegmentedControl(items: tabs)
    segmentControl.selectedSegmentIndex = 0
    segmentControl.addTarget(self, action: #selector(_changeAction), for: .valueChanged)

    if #available(iOS 13.0, *) {
        self.view.backgroundColor = .systemGray6
        _textView.textColor = .label
    } else {
        self.view.backgroundColor = .white
        _textView.textColor = .black
    }
    _textView.isEditable = false
    _textView.backgroundColor = .clear
    
    _uiScrollView.isScrollEnabled = true
    self.view.addSubview(_uiScrollView)

    _uiScrollView.addSubview(segmentControl)
    _uiScrollView.addSubview(_textView)
    button = UIBarButtonItem(title: "Copy", style: .plain, target: self, action: #selector(_copyText))
    
    self.navigationItem.rightBarButtonItem = button
    self.navigationController?.isNavigationBarHidden = false
    self.navigationController?.isToolbarHidden = true
  }

  @objc func _copyText(_ sender: Any?) {
    UIPasteboard.general.string = "request: \(requestInfo) \n response: \(responseInfo)"
    self._feedback.notificationOccurred(.success)
  }
  
  @objc func _changeAction(sender: UISegmentedControl) {
      switch sender.selectedSegmentIndex {
      case 0:
        _textView.text = requestInfo
      default:
        _textView.text = responseInfo
      }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    segmentControl.selectedSegmentIndex = 0
    _textView.text = requestInfo
  }
  
  override func viewDidLayoutSubviews() {
    let frame = self.view.bounds
    segmentControl.frame = CGRect(x: frame.minX + 10, y: 10, width: frame.width - 20, height: 34)
    _uiScrollView.frame = frame
    _textView.frame = CGRect(x: segmentControl.frame.minX, y: segmentControl.frame.maxY, width: frame.width - 20, height: self.view.bounds.height)
    
    _uiScrollView.contentSize = self.view.frame.size
  }
}
