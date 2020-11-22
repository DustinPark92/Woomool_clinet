//
//  CouponHeader.swift
//  Woomool
//
//  Created by Dustin on 2020/11/13.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class CouponHeader: UICollectionReusableView {
    
    let mainLabel : UILabel = {
        let lb = UILabel()
        lb.text = "사용할 구폰을 선택해주세요."
        lb.font = UIFont.NotoRegular16
        lb.textColor = .black
        lb.textAlignment = .center
        return lb
    }()
    
    let subLabel : UILabel = {
        let lb = UILabel()
        lb.text = "- 타쿠폰 중복할인 불가능 \n- 1회성 쿠폰으로 사용시 소멸됩니다."
        lb.textAlignment = .center
        lb.numberOfLines = 0
        lb.textColor = .black400
        return lb
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mainLabel)
        addSubview(subLabel)
        backgroundColor = .white
        mainLabel.centerX(inView: self, topAnchor: topAnchor, paddingTop: 24)
        subLabel.centerX(inView: self, topAnchor: mainLabel.bottomAnchor, paddingTop: 6)
        
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
