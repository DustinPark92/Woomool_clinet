//
//  HowToUserCollectionViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/09/19.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class HowToUseCollectionViewCell: UICollectionViewCell {
    
    var option: HowToUseOption! {
        didSet {
            howToUseLabel.text = option.description
            howToUseRemarkLabel.text = option.remark
            howToUseImg.image = option.image
        }
    }
    
    let howToUseLabel : UILabel = {
        let lb = UILabel()
        lb.font = UIFont.NotoLight30
        lb.textColor = .black900
        lb.numberOfLines = 0
        return lb
    }()
    
    let howToUseImg : UIImageView = {
        let iv = UIImageView()
//        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .white
        return iv
    }()
    
    let howToUseRemarkLabel : UILabel = {
        let lb = UILabel()
        lb.font = UIFont.NotoRegular16
        lb.textColor = .black900
        lb.backgroundColor = .white
        
        return lb
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(howToUseLabel)
        addSubview(howToUseImg)
        addSubview(howToUseRemarkLabel)
        
        howToUseLabel.anchor(top:topAnchor,left: leftAnchor,paddingTop: 20,paddingLeft: 40)
        howToUseImg.anchor(top:topAnchor,left:leftAnchor,bottom: bottomAnchor,right: rightAnchor,paddingTop: 184,paddingLeft:24,paddingBottom: 79,paddingRight: 24)
        howToUseRemarkLabel.anchor(left: leftAnchor,bottom: bottomAnchor,paddingTop: 20,paddingLeft: 40,paddingBottom: 40)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
