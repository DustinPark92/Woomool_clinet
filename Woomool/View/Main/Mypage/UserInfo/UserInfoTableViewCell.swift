//
//  UserInfoTableViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/09/03.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class UserInfoTableViewCell: UITableViewCell {
    
    
    var option: userInfoType! {
        didSet { titleLabel.text = option.description }
    }
    
    let titleLabel : UILabel = {
        let lb = UILabel()
        lb.textColor = .black900
        lb.font = UIFont.NotoMedium14
        lb.setDimensions(width: 100, height: 20)
       return lb
    }()
    
    let textField : UITextField = UserInfoViewModel().textField(withPlaceholder: "김우물")
    
    let editButton : UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "right_arrow"), for: .normal)
        bt.setDimensions(width: 24, height: 24)
        return bt
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(titleLabel)
        addSubview(textField)
        addSubview(editButton)
        
        
        editButton.isHidden = true
        titleLabel.anchor(top:topAnchor,left: leftAnchor,paddingTop: 22,paddingLeft: 32)
        
        textField.anchor(top:topAnchor,left: titleLabel.rightAnchor,paddingTop: 21,paddingLeft: 17)
        
        editButton.anchor(top:topAnchor,right: rightAnchor,paddingTop: 20,paddingRight: 32)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
