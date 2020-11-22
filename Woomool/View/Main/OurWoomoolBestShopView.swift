//
//  MyWoomoolBestShopView.swift
//  Woomool
//
//  Created by Dustin on 2020/09/02.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class OurWoomoolBestShopView: UIView {
    
    let viewModel = OurwoomoolViewModel()
    
    var titleLabel : UILabel = {
        let lb = UILabel()
        lb.text = "베스트 우물"
        lb.textColor = .white
        lb.font = UIFont.NotoBold16
        return lb
    }()
    
    lazy var plusButton = viewModel.attributedButton("+ 더보기")
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(plusButton)
        
        titleLabel.anchor(top:topAnchor,left: leftAnchor,paddingTop: 5.04,paddingLeft: 20)
        plusButton.anchor(top:topAnchor,bottom:bottomAnchor,right: rightAnchor ,paddingTop: 9,paddingBottom: 9,paddingRight: 14,width: 43,height: 18)
        backgroundColor = UIColor.blue500
        makeAborder(radius: 14)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
