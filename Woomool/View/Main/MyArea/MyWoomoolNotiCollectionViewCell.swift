//
//  MyWoomoolNotiCollectionViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/09/02.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class MyWoomoolNotiCollectionViewCell: UICollectionViewCell {

    let notiImg : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.setDimensions(width: 40, height: 40)
        return iv
    }()
    
    lazy var notiLabel : UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.gray500
        lb.font = UIFont.NotoMedium12
        return lb
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(notiImg)
        addSubview(notiLabel)
        
        notiImg.centerX(inView: self, topAnchor: topAnchor, paddingTop: 6)
        notiLabel.centerX(inView: self, topAnchor: notiImg.bottomAnchor, paddingTop: 0)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
