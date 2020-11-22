//
//  WoomoolImageCell.swift
//  Woomool
//
//  Created by Dustin on 2020/10/30.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class WoomoolImageCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.addConstraintsToFillView(self)
        imageView.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
