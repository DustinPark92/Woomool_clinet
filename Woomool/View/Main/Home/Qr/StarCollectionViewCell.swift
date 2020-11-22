//
//  StarCollectionViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/09/03.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class StarCollectionViewCell: UICollectionViewCell {
    
    let starButton : UIButton = {
        let bt = UIButton()
        bt.setDimensions(width: 30, height: 30)
        bt.setImage(UIImage(named: "noStar"), for: .normal)
        return bt
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        addSubview(starButton)
        starButton.anchor(top:topAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor)
        
        
    }
    
    
    override var isSelected: Bool {
        didSet {
            starButton.backgroundColor = isSelected ? UIColor.lightGray : UIColor.black
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
