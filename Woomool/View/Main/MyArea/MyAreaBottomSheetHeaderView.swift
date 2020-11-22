//
//  MyAreaBottomSheetView.swift
//  Woomool
//
//  Created by Dustin on 2020/09/02.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MyAreaTableViewCell"

class MyAreaBottomSheetHeaderView: UIView {
    
    
    let color = UIColor()
    
    var bottomSheetHidden = false
    
    lazy var topButton : UIButton = {
        let bt = UIButton()
        bt.backgroundColor = UIColor.gray300
        bt.setDimensions(width: 60, height: 6)
        bt.makeAborder(radius: 10)
        return bt
    }()

    
    lazy var distanceNotiLabel : UILabel = {
        let lb = UILabel()
        lb.text = "현위치에서 2km 이내의 우물 목록입니다."
        lb.textColor = UIColor.black400
        lb.font = UIFont.NotoMedium12
        return lb
    }()
    
    

    override init(frame: CGRect) {
        super.init(frame:frame)
        addSubview(topButton)
        addSubview(distanceNotiLabel)
        topButton.centerX(inView: self, topAnchor: topAnchor, paddingTop: 24)
        distanceNotiLabel.centerX(inView: self, topAnchor: topButton.bottomAnchor, paddingTop: 5)
        backgroundColor = .white
    
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    

}
