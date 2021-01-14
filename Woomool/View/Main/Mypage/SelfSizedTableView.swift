//
//  SelfSizedTableView.swift
//  Woomool
//
//  Created by Dustin on 2020/09/02.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class SelfSizedTableView: UITableView {

      override public func layoutSubviews() {
          super.layoutSubviews()
          if bounds.size != intrinsicContentSize {
              invalidateIntrinsicContentSize()
          }
      }

      override public var intrinsicContentSize: CGSize {
          return contentSize
      }
    
    
    
    
    
}


