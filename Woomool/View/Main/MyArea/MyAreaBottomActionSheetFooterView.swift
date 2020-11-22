//
//  MyAreaBottomActionSheetFooterView.swift
//  Woomool
//
//  Created by Dustin on 2020/09/02.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

protocol MyAreaBottomActionSheetFooterViewDelegate : class {
    func handleRequest()
}

class MyAreaBottomActionSheetFooterView: UIView {
    
    let color = UIColor()
    
   weak var delegate : MyAreaBottomActionSheetFooterViewDelegate?
    
     let serviceRequestButton : UIButton = {
        let bt = UIButton()
        bt.setTitle("우물 서비스 요청", for: .normal)
        bt.titleLabel?.font = UIFont.NotoBold18
        bt.titleLabel?.textColor = .white
        bt.backgroundColor = UIColor.blue500
        bt.makeAborder(radius: 14)
        return bt
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(serviceRequestButton)
        serviceRequestButton.centerX(inView: self, topAnchor: topAnchor, paddingTop: 23)
        serviceRequestButton.setDimensions(width: 300, height: 56)
        serviceRequestButton.addTarget(self, action: #selector(handleRequest), for: .touchUpInside)
        backgroundColor = .white
        
    }
    
    @objc func handleRequest() {
        delegate?.handleRequest()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



