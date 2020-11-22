//
//  CouponCollectionViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/09/18.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class CouponCollectionViewCell: UICollectionViewCell {
    
    let viewModel = MypageViewModel()
    
    let couponImage : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "coupon")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let titleLabel : UILabel = {
        let lb = UILabel()
        lb.text = "월요병 안녕 쿠폰"
        lb.font = UIFont.NotoBold16
        lb.textColor = .black900
        return lb
    }()
    
    let contentsLabel : UILabel = {
        let lb = UILabel()
        lb.text = "월요일에 이용권 구매하면 이용권 한개가 더!\n두줄로 설명하는 상황!"
        lb.font = UIFont.NotoMedium12
        lb.textColor = .black400
        lb.numberOfLines = 0
        return lb
    }()
    
    let dDayLabel : UILabel = {
        let lb = UILabel()
        lb.text = "D-30"
        lb.font = UIFont.NotoMedium12
        lb.textColor = .blue500
        
        return lb
    }()
    
    let dateLabel : UILabel = {
        let lb = UILabel()
        lb.text = "2020.10.31까지"
        lb.font = UIFont.NotoMedium12
        lb.textColor = .black400
        return lb
        
    }()
    
    lazy var detailButton : UIButton = {
        let bt = UIButton()
        bt.setDimensions(width: 24, height: 24)
        bt.setImage(UIImage(named: "download"), for: .normal)
        
        return bt
    }()

    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(couponImage)
        addSubview(titleLabel)
        addSubview(contentsLabel)
        addSubview(dDayLabel)
        addSubview(dateLabel)
        addSubview(detailButton)
        couponImage.anchor(top:topAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor,width: frame.width,height: frame.height)
        titleLabel.anchor(top:couponImage.topAnchor,left:couponImage.leftAnchor,paddingTop:24,paddingLeft: 24)
        contentsLabel.anchor(top:titleLabel.bottomAnchor,left: couponImage.leftAnchor,right: rightAnchor,paddingTop: 2,paddingLeft: 24,paddingRight: 78)
        dDayLabel.anchor(left: couponImage.leftAnchor,bottom: bottomAnchor,paddingLeft: 24,paddingBottom: 12)
        dateLabel.anchor(left: dDayLabel.rightAnchor,bottom: bottomAnchor,paddingLeft: 4,paddingBottom: 12)
        
        detailButton.anchor(top:couponImage.topAnchor,right: couponImage.rightAnchor,paddingTop: 40,paddingRight: 40)
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
