//
//  MainCollectionViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/08/27.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    

     let bannerImg : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.image = UIImage(named: "bannerExample")
        return iv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(bannerImg)
        
        bannerImg.anchor(top:topAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor)
        
        self.makeAborder(radius: 5)

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
