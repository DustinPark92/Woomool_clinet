//
//  BestWoomoolCollectionViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/09/12.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class BestWoomoolCollectionViewCell: UICollectionViewCell {
    
    let rankLabel : UILabel = {
        let lb = UILabel()
        lb.font = UIFont.NotoMedium14
        lb.textColor = .white
        return lb
    }()
    
    let storeNameLabel : UILabel = {
        let lb = UILabel()
        lb.font = UIFont.NotoBold16
        lb.textColor = .white
        return lb
    }()
    
    let adressLabel : UILabel = {
        let lb = UILabel()
        lb.font = UIFont.NotoMedium14
        return lb
    }()
    
    let upDownLabel : UILabel = {
        let lb = UILabel()
        lb.text = "-"
        lb.font = UIFont.NotoMedium14
        lb.textColor = .white
        return lb
    }()
    
    
    
    let mainImageView : UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    let rateImg : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "icon_bestWoomool")
        iv.setDimensions(width: 18, height: 18)
        
        return iv
    }()
    
    let rateLabel : UILabel = {
        let lb = UILabel()
        lb.text = "5.0"
        lb.font = UIFont.RobotoRegular14
        lb.textColor = .white
        
        return lb
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(mainImageView)
        addSubview(rankLabel)
        addSubview(storeNameLabel)
        addSubview(adressLabel)
        addSubview(upDownLabel)
        addSubview(rateImg)
        addSubview(rateLabel)
        
        
        mainImageView.anchor(top:topAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor)
        
        rankLabel.anchor(top:topAnchor,left: leftAnchor,paddingTop: 20,paddingLeft: 20.19)
        
        storeNameLabel.anchor(top:topAnchor,left: rankLabel.rightAnchor,paddingTop: 16,paddingLeft: 20)
        upDownLabel.anchor(top:rankLabel.bottomAnchor,left: leftAnchor,paddingTop: 2,paddingLeft: 22)
        
        adressLabel.anchor(top:storeNameLabel.bottomAnchor,left: mainImageView.leftAnchor,right: mainImageView.rightAnchor,paddingTop: 0,paddingLeft: 44,paddingRight: 10)
        
        
        rateLabel.anchor(top:topAnchor,right: rightAnchor,paddingTop: 21,paddingRight:19.81)
        
        rateImg.anchor(top:topAnchor,right: rateLabel.leftAnchor,paddingTop:20 ,paddingRight:6 )
        
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
