//
//  SharedStorage.swift
//  RNWidget
//
//  Created by Trinh Chin on 3/14/22.
//

import UIKit
import WidgetKit

@objc(SharedStorage)
class SharedStorage: NSObject {
  @objc static func requiresMainQueueSetup() -> Bool {
    return false
  }
  
  @objc func refreshWidget() -> Void {
    DispatchQueue.main.async {
      self._refreshWidget()
    }
  }
  
  @objc func _refreshWidget() -> Void {
    if #available(iOS 14.0, *) {
      WidgetCenter.shared.reloadAllTimelines()
    } else {
      // Fallback on earlier versions
    }
  }
}
