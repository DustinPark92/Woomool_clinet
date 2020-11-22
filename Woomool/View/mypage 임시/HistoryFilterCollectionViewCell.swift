//
//  HistoryFilterCollectionViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/09/08.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit


class HistoryFilterCollectionViewCell: UICollectionViewCell {


    
    var option: MypageHistroyOption! {
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
            backgroundColor = isSelected ? .blue500 : .white
            titleLabel.textColor = isSelected ? .white : .gray400
            
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
