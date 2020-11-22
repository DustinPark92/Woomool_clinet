//
//  MainCollectionViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/08/27.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    private let subjectLabel : UILabel = {
        let lb = UILabel()
        lb.text = "EVENT"
        lb.font = UIFont.systemFont(ofSize: 8)
        return lb
    }()
    
    
    private let titleLabel : UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.text = "삼양 여관 제휴기념 30%할인\n쿠폰받으러가기"
        return lb
    }()
    
    private let bannerImg : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.image = UIImage(named: "bannerExample")
        return iv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(subjectLabel)
        addSubview(titleLabel)
        addSubview(bannerImg)
        
        bannerImg.anchor(top:topAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor)
        
        self.makeAborder(radius: 5)
        self.backgroundColor = .orange
        subjectLabel.anchor(top:topAnchor,left: leftAnchor,paddingTop: 14,paddingLeft: 16)
        titleLabel.anchor(top:subjectLabel.bottomAnchor,left: leftAnchor,paddingTop: 2,paddingLeft: 16)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
