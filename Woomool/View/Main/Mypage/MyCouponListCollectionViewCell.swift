//
//  MyCouponListCollectionViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/08/27.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class MyCouponListCollectionViewCell: UICollectionViewCell {
    
    
    lazy var mainView : UIView = MypageViewModel().CouponView(topLabel: couponLabel, bottomLabel: coupongCount, imageView:couponImg, sv: sv)

    let color = UIColor()
    
    let sv = UIView()
    
    let couponImg : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.setDimensions(width: 44, height: 44)
        return iv
    }()
    
    lazy var couponLabel : UILabel = {
        let lb = UILabel()
        lb.text = "구매"
        lb.textColor = UIColor.black400
        lb.font = UIFont.NotoMedium12
        return lb
    }()
    
    lazy var coupongCount : UILabel = {
        let lb = UILabel()
        lb.text = "12"
        lb.textColor = UIColor.black900
        lb.font = UIFont.RobotoBold20
        return lb
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mainView)
        mainView.anchor(top:topAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
