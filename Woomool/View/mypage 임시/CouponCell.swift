//
//  CouponCell.swift
//  Woomool
//
//  Created by Dustin on 2020/11/13.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class CouponCell: UICollectionViewCell {
    
    
    let typeImage : UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 50, height: 50)
        iv.image = UIImage(named: "couponPlus")
        return iv
    }()
    
    let mainLabel : UILabel = {
        let lb = UILabel()
        lb.text = "월요병 안녕, 월요일 이용권 구매시"

        lb.font = UIFont.NotoMedium12
        lb.textColor = .blue500
        return lb
    }()
    
    let subLabel : UILabel = {
        let lb = UILabel()
        lb.text = "1000원 할인 쿠폰"
        lb.font = UIFont.NotoRegular16
        lb.textColor = .black900
        return lb
    }()
    
    let dateLabel : UILabel = {
        let lb = UILabel()
        lb.text = "2020.10.01 ~ 2020.10.31"
        lb.font = UIFont.NotoMedium12
        lb.textColor = .black400
        return lb
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mainLabel)
        addSubview(subLabel)
        addSubview(typeImage)
        addSubview(dateLabel)
        
        
        typeImage.anchor(top:topAnchor,left: leftAnchor,paddingTop:25 ,paddingLeft: 24)
        mainLabel.anchor(top:topAnchor,left: typeImage.rightAnchor,paddingTop: 16,paddingLeft: 14.5)
        subLabel.anchor(top:mainLabel.bottomAnchor,left: typeImage.rightAnchor,paddingTop: 0,paddingLeft: 14.5)
        dateLabel.anchor(top:subLabel.bottomAnchor,left: typeImage.rightAnchor,paddingTop: 8,paddingLeft: 14.5)
        
        makeAborderWidth(border: 1, color: UIColor.gray300.cgColor)
        makeAborder(radius: 14)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
