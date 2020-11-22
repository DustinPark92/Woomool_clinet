//
//  WoomoolServieceHeaderView.swift
//  Woomool
//
//  Created by Dustin on 2020/09/18.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class WoomoolServieceHeaderView: UIView {
    
    let mainLabel : UILabel = {
        let lb = UILabel()
        lb.text = "내 최애 카페가 우물로!"
        lb.font = UIFont.NotoRegular16
        lb.textColor = .blue500
        return lb
    }()
    
    let subLabel : UILabel = {
        let lb = UILabel()
        lb.text = "우물이 되었으면 하는 카페 정보를 입력해주세요. \n언제 어디서나 우물생활!"
        lb.font = UIFont.NotoMedium12
        lb.textColor = .black400
        lb.numberOfLines = 0
        return lb
    }()
    
    let mainImage : UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 122, height: 120)
        iv.image = UIImage(named: "woomoolServiceRequest")
        
        return iv
    
    }()
    
    let seperatorView : UIView = {
        let uv = UIView()
        uv.backgroundColor = .bestAsk
        return uv
    }()
    
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(mainLabel)
        addSubview(subLabel)
        addSubview(mainImage)
        addSubview(seperatorView)
        
        mainLabel.centerX(inView: self, topAnchor: topAnchor, paddingTop: 24)
        subLabel.centerX(inView: self, topAnchor: mainLabel.bottomAnchor, paddingTop: 2)
        
        mainImage.centerX(inView: self, topAnchor: subLabel.bottomAnchor, paddingTop: 8)
        
        seperatorView.anchor(left:leftAnchor,bottom: bottomAnchor,right: rightAnchor,width: frame.width , height: 10)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
