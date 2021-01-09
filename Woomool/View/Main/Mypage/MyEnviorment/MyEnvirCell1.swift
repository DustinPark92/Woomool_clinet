//
//  MyEnvirCell1.swift
//  Woomool
//
//  Created by Dustin on 2020/12/05.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class MyEnvirCell1: UICollectionViewCell {
    
    let mainLabel : UILabel = {
        let lb = UILabel()
        lb.text = "나의 일회용 컵 소비 억제 횟수"
        lb.font = UIFont.NotoMedium14
        lb.textColor = .white
        return lb
    }()
    
    let subLabel : UILabel = {
        let lb = UILabel()

        lb.font = UIFont.NotoMedium20
        lb.textColor = .white
        return lb
    }()
    
    let mainImageView : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "best_rank_1")
        iv.backgroundColor = .blue500
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeAborder(radius: 14)
        backgroundColor = .white
        
        addSubview(mainImageView)
        mainImageView.addConstraintsToFillView(self)
        mainImageView.addSubview(mainLabel)
        mainLabel.anchor(top:topAnchor,left: leftAnchor,paddingTop: 21,paddingLeft: 16)
        mainImageView.addSubview(subLabel)
        subLabel.anchor(top:mainLabel.bottomAnchor,left: leftAnchor,paddingTop: 0,paddingLeft: 16)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
