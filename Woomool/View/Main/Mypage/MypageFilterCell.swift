//
//  MypageCollectionViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/08/27.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class MypageFilterCell: UICollectionViewCell {


    
    var option: MypageFilterOptions! {
        didSet { titleLabel.text = option.description }
    }
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.NotoMedium14
        
        return label
    }()
    
    override var isSelected: Bool {
        didSet {

            titleLabel.textColor = isSelected ? .gray500: .black400
            
        }
    }
    
    
    //MARK: - LifeCycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        

        addSubview(titleLabel)
        titleLabel.center(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
