//
//  OnBoardingCollectionViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/08/29.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class OnBoardingCollectionViewCell: UICollectionViewCell {
    
    

    let mainLabel : UILabel = {
        let lb = UILabel()
        lb.text = "잠들어있는 텀블러와 함께 \n우물을 찾아 떠나요"
        lb.numberOfLines = 0
        lb.textAlignment = .center
        lb.font = UIFont.NotoMedium26
        return lb
    }()
    
    let onBoardingImgView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mainLabel)
        
        mainLabel.centerX(inView: self, topAnchor:topAnchor, paddingTop: 10)
        mainLabel.anchor(height: 80)
        
        
        addSubview(onBoardingImgView)
        onBoardingImgView.anchor(top:mainLabel.bottomAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor,paddingTop: 20)
        onBoardingImgView.setDimensions(width: 230, height: 230)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
