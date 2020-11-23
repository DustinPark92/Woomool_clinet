//
//  MyAreaBottomSheetCafeDetail.swift
//  Woomool
//
//  Created by Dustin on 2020/11/13.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class MyAreaBottomSheetCafeDetail: UIView {

    lazy var cafeNameLabel : UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.black900
        lb.font = UIFont.NotoMedium20
        lb.text = "카페 알파카"
        return lb
    }()
    lazy var distanceLabel : UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.blue500
        lb.font = UIFont.NotoMedium14
        lb.text = "2M"
        return lb
    }()
    
    let newImageView : UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 24, height: 24)
        iv.image = UIImage(named: "icon_newWoomool")
        return iv
    }()
    let bestImageView : UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 24, height: 24)
        iv.image = UIImage(named: "icon_bestWoomool")
        return iv
    }()
    
    let adressImageView : UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 24, height: 24)
        iv.image = UIImage(named: "map")
        return iv
    }()
    
    let timeImageView : UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 24, height: 24)
        iv.image = UIImage(named: "time")
        return iv
    }()
    
    let phoneImageView : UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 24, height: 24)
        iv.image = UIImage(named: "call")
        return iv
    }()
    
    let adressLabel : UILabel = {
        let lb = UILabel()
        lb.font = UIFont.NotoMedium14
        lb.textColor = .black400
        lb.text = "서울 광진구 능동로 200"
        return lb
    }()
    
    let timeLabel : UILabel = {
        let lb = UILabel()
        lb.font = UIFont.NotoMedium14
        lb.textColor = .black400
        lb.text = "영업시간 매일 08:00 ~ 23:00"
        return lb
    }()
    
    let phoneLabel : UILabel = {
        let lb = UILabel()
        lb.font = UIFont.NotoMedium14
        lb.textColor = .black400
        lb.text = "02 - 1234- 1234"
        return lb
    }()
    
    let scopeLabel : UILabel = {
        let lb = UILabel()
        lb.text = "5.0"
        lb.font = UIFont.NotoMedium12
        lb.textColor = .blue700
        return lb
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(cafeNameLabel)
        addSubview(distanceLabel)
        addSubview(newImageView)
        addSubview(bestImageView)
        addSubview(adressImageView)
        addSubview(timeImageView)
        addSubview(phoneImageView)
        addSubview(adressLabel)
        addSubview(timeLabel)
        addSubview(phoneLabel)
        addSubview(scopeLabel)
        
        
        cafeNameLabel.anchor(top:topAnchor,left: leftAnchor,paddingLeft: 24)
        distanceLabel.anchor(top:topAnchor,left: cafeNameLabel.rightAnchor,paddingTop:8,paddingLeft: 8)
        
        bestImageView.anchor(top:topAnchor,right: rightAnchor,paddingTop: 16.5,paddingRight: 24)
        newImageView.anchor(top:topAnchor,right: bestImageView.leftAnchor,paddingTop: 16.5,paddingRight: 8)
        

        scopeLabel.anchor(top:bestImageView.bottomAnchor,right:rightAnchor,paddingTop: 2,paddingRight: 28)
        
        adressImageView.anchor(top:cafeNameLabel.bottomAnchor,left: leftAnchor,paddingTop: 16,paddingLeft: 15)
        timeImageView.anchor(top:adressImageView.bottomAnchor,left: leftAnchor,paddingTop: 16,paddingLeft: 15)
        phoneImageView.anchor(top:timeImageView.bottomAnchor,left: leftAnchor,paddingTop: 16,paddingLeft: 15)
        
        adressLabel.anchor(top:cafeNameLabel.bottomAnchor,left: adressImageView.rightAnchor,paddingTop:16 ,paddingLeft: 8,height: 24)
        timeLabel.anchor(top:adressLabel.bottomAnchor,left: timeImageView.rightAnchor,paddingTop:16 ,paddingLeft: 8,height: 24)
        phoneLabel.anchor(top:timeLabel.bottomAnchor,left: phoneImageView.rightAnchor,paddingTop:16 ,paddingLeft: 8,height: 24)
        
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
