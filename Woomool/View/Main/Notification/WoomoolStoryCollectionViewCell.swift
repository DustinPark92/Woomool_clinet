//
//  WoomoolStoryCollectionViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/10/23.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class WoomoolStoryCollectionViewCell: UICollectionViewCell {
    
    var option: woomoolStoryOption! {
        didSet {

            mainImageView.image = option.image
        }
    }
    
    let mainImageView : UIImageView = {
        let iv = UIImageView()
        
        return iv
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mainImageView)
        mainImageView.addConstraintsToFillView(self)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
