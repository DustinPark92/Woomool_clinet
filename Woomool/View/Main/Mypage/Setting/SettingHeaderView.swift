//
//  SettingHeaderView.swift
//  Woomool
//
//  Created by Dustin on 2020/09/06.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class SettingHeaderView: UIView {
    
    let mainImage : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.setDimensions(width: 30, height: 30)
        iv.image = UIImage(named: "setting_service")
        return iv
    }()
    
    let mainLabel : UILabel = {
        let lb = UILabel()
        lb.font = UIFont.NotoMedium12
        lb.textColor = .black400
        lb.text = "고객 지원"
        return lb
    }()
    

    override init(frame: CGRect) {
        super.init(frame:frame)
        
        addSubview(mainImage)
        addSubview(mainLabel)
        
        mainImage.anchor(left: leftAnchor,bottom: bottomAnchor,paddingLeft: 24)
        mainLabel.anchor(left: mainImage.rightAnchor,bottom: bottomAnchor,paddingLeft: 2,paddingBottom: 6)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
