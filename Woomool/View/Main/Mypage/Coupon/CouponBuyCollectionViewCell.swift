//
//  CouponBuyCollectionViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/09/07.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class CouponBuyCollectionViewCell: UICollectionViewCell {
    
    let couponImg : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "coupon_Img")
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    let couponQuantityLabel : UILabel = {
        let lb = UILabel()
        lb.text = "15"
        lb.font = UIFont.NanumExtraBold34
        lb.textColor = .white
        return lb
    }()
    
    let couponQuantityRightLabel : UILabel = {
        let lb = UILabel()
        lb.text = "회"
        lb.font = UIFont.NanumExtraBold16
        lb.textColor = .white
        return lb
    }()
    
    let priceLabel : UILabel = {
        let lb = UILabel()
        lb.text = "9,900원"
        lb.textColor = .black900
        lb.font = UIFont.NotoBold16
        return lb
    }()
    let couponDescriptionLabel : UILabel = {
        let lb = UILabel()
        lb.text = "결제당 1000원 \n 할인 15회 이용권"
        lb.font = UIFont.NotoMedium12
        lb.textColor = .black400
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        addSubview(couponImg)
        addSubview(couponQuantityLabel)
        addSubview(couponQuantityRightLabel)
        addSubview(priceLabel)
        addSubview(couponDescriptionLabel)
        makeAborder(radius: 14)
        makeAborderWidth(border: 3, color: UIColor.gray300.cgColor)
        
        
        couponImg.anchor(top:topAnchor,left: leftAnchor,paddingTop:22 ,paddingLeft:27 )
        couponQuantityLabel.anchor(top:topAnchor,left: leftAnchor,paddingTop: 47.65 ,paddingLeft: 38.27)
        couponQuantityRightLabel.anchor(top:topAnchor,left: couponQuantityLabel.rightAnchor,paddingTop:57.65 ,paddingRight:1.38 )
        priceLabel.centerX(inView: self, topAnchor: couponImg.bottomAnchor, paddingTop: 1.27)
        couponDescriptionLabel.centerX(inView: self, topAnchor: priceLabel.bottomAnchor, paddingTop: 2)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isSelected: Bool {
        didSet {
            layer.borderColor = isSelected ? UIColor.blue500.cgColor : UIColor.gray300.cgColor
            
            if isSelected {
                dropShadow(opacity: 0.5)
            } else {
                dropShadow(opacity: 0)
            }
            
        }
    }
    
}
