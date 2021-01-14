//
//  SignUpTableViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/08/29.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class SignUpTableViewCell: UITableViewCell {
    
    let mainLabel : UILabel = {
        let lb = UILabel()
        lb.text = "이메일 인증"
        lb.font = UIFont.NotoBold16
        lb.textColor = .black900
        return lb
    }()
    
    let mainLabelInvalid : UILabel = {
        let lb = UILabel()
        lb.text = ""
        lb.textColor = .blue500
        lb.font = UIFont.NotoBold16
        return lb
    }()
    
    lazy var ContainerView: UIView = {
        let view = SignUpViewModel().inputContainerView(textField: TextField, label: bottomLabel, sv: sv)
        return view
        
    }()
    
    let requiredLabel : UILabel = {
        let lb = UILabel()
        lb.text = "*"
        lb.textColor = .blue500
        lb.font = UIFont.NotoBold16
        return lb
    }()
    
    var sv = UIView()
    
    lazy var bottomLabel : UILabel = SignUpViewModel().Label()

    lazy var TextField : UITextField = SignUpViewModel().textField()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(mainLabel)
        contentView.addSubview(ContainerView)
        contentView.addSubview(mainLabelInvalid)
        
        contentView.addSubview(requiredLabel)

        
        
        mainLabelInvalid.anchor(top:topAnchor,left: leftAnchor,paddingLeft: 50)

        mainLabel.anchor(top:topAnchor,left: leftAnchor,paddingLeft: 50)
        requiredLabel.anchor(top:topAnchor,left: mainLabel.rightAnchor,paddingRight: 1)
        ContainerView.anchor(top:mainLabel.bottomAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor ,paddingLeft: 41,paddingRight: 39)
        
        
        contentView.setDimensions(width: frame.width, height: 100)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}
