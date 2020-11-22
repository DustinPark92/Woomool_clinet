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
        iv.image = UIImage(named: "icon_bestWoomool")
        return iv
    }()
    let bestImageView : UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 24, height: 24)
        iv.image = UIImage(named: "icon_newWoomool")
        return iv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(cafeNameLabel)
        addSubview(distanceLabel)
        addSubview(newImageView)
        addSubview(bestImageView)
        
        
        cafeNameLabel.anchor(top:topAnchor,left: leftAnchor,paddingLeft: 24)
        distanceLabel.anchor(top:topAnchor,left: cafeNameLabel.rightAnchor,paddingTop:8,paddingLeft: 8)
        
        bestImageView.anchor(top:topAnchor,right: rightAnchor,paddingTop: 16.5,paddingRight: 24)
        newImageView.anchor(top:topAnchor,right: bestImageView.leftAnchor,paddingTop: 16.5,paddingRight: 8)
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
