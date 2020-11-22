//
//  PhoneAuthTableViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/09/14.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class PhoneAuthNameTableViewCell: UITableViewCell {
    
    let viewModel = PhoneAuthViewModel()
    
    let titleLabel : UILabel = {
        let lb = UILabel()
        lb.text = "이름"
        lb.font = UIFont.NotoBold16
        lb.textColor = .black900
        return lb
    }()
    
    lazy var countryContainerView = viewModel.containerViewWithButton(selectButton: selectButton, countryLabel: countryLabel)
    
    
    lazy var countryLabel = viewModel.containerLabel(text: "내국인")
    
    lazy var selectButton = UIButton(type: .system)
    
    
    
    lazy var nameContainerView = viewModel.containerViewTextField(textField: nameTextField)
    
    lazy var nameTextField = viewModel.textField(text: "김우물")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(countryContainerView)
        contentView.addSubview(nameContainerView)
        
        titleLabel.anchor(top:topAnchor,left: leftAnchor,paddingTop: 24,paddingLeft: 40)
        
        countryContainerView.anchor(top:titleLabel.bottomAnchor,left: leftAnchor,bottom: bottomAnchor,paddingTop:7 ,paddingLeft: 40,width: frame.width / 2.5)
        
        nameContainerView.anchor(top:titleLabel.bottomAnchor,left:countryContainerView.rightAnchor,right: rightAnchor,paddingTop: 7,paddingLeft: 8,paddingRight: 40,width: frame.width / 2.5)
        
        contentView.setDimensions(width: frame.width, height: 86)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
