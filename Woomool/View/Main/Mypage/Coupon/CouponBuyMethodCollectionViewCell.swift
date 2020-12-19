//
//  CouponBuyMethodCollectionViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/12/13.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class CouponBuyMethodCollectionViewCell: UICollectionViewCell {
    
    
    var indexPath = 0 
    
    let mainLabel : UILabel = {
        let lb = UILabel()
        lb.text = "카드 결제"
        lb.font = UIFont.NotoMedium14
        lb.textColor = .black400
        return lb
    }()
    
    let mainImageView : UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 28, height: 28)
        iv.image = UIImage(named: "bankActive")
        return iv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeAborderWidth(border: 1, color: UIColor.gray300.cgColor)
        addSubview(mainImageView)
        addSubview(mainLabel)
        
        mainImageView.anchor(top:topAnchor,left: leftAnchor,paddingTop:14 ,paddingLeft: 24)
        
        mainLabel.anchor(top:topAnchor,left: mainImageView.rightAnchor,paddingTop:16 ,paddingLeft: 8)
        
        
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                makeAborderWidth(border: 1, color: UIColor.blue500.cgColor)
                mainLabel.textColor = .black900
                mainImageView.image = mainImageView.image?.withRenderingMode(.alwaysTemplate)
                mainImageView.tintColor = UIColor.black900
                
            } else {
                makeAborderWidth(border: 1, color: UIColor.gray300.cgColor)
                mainLabel.textColor = .black400
                mainImageView.image = mainImageView.image?.withRenderingMode(.alwaysTemplate)
                mainImageView.tintColor = UIColor.black400
                
            }
            
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
