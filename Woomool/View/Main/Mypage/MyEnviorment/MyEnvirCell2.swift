//
//  MyEnvirCell2.swift
//  Woomool
//
//  Created by Dustin on 2020/12/05.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class MyEnvirCell2: UICollectionViewCell {
    
    
    let mainLabel : UILabel = {
        let lb = UILabel()
        lb.text = "나의 탄소 저감량"
        lb.font = UIFont.NotoMedium14
        lb.textColor = .black400
        return lb
    }()
    
    let subLabel : UILabel = {
        let lb = UILabel()
        lb.text = "0.5g"
        lb.font = UIFont.NotoMedium20
        lb.textColor = .black900
        return lb
    }()
    
    let descriptionLabel : UILabel = {
        let lb = UILabel()
        lb.text = "탄소 0.5g은 소나무 1그루를\n심는 효과와 같아요!"
        lb.numberOfLines = 0
        lb.textColor = .black400
        return lb
    }()
    
    let mainImageView : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "tree")
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeAborder(radius: 14)
        backgroundColor = .white
        
        addSubview(mainImageView)
        mainImageView.anchor(top:topAnchor,bottom: bottomAnchor,right: rightAnchor,width: 128,height: 120)
        addSubview(mainLabel)
        mainLabel.anchor(top:topAnchor,left: leftAnchor,paddingTop: 21,paddingLeft: 16)
        addSubview(subLabel)
        subLabel.anchor(top:mainLabel.bottomAnchor,left: leftAnchor,paddingTop: 0,paddingLeft: 16)
        addSubview(descriptionLabel)
        descriptionLabel.anchor(top:subLabel.bottomAnchor,left: leftAnchor,paddingTop:6 ,paddingLeft: 17)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
