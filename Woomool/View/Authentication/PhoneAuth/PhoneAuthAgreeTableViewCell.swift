//
//  PhoneAuthAgreeTableViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/09/14.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class PhoneAuthAgreeTableViewCell: UITableViewCell {
    
    
    let checkBoxButton : UIButton = {
        let bt = UIButton()
        bt.setDimensions(width: 18, height: 18)
        bt.setImage(UIImage(named: "checkbox_active"), for: .normal)
        return bt
    }()
    
    let agreeLabel : UILabel = {
        let lb = UILabel()
        lb.text = "본인확인 서비스 이용약관 전체 동의"
        lb.font = UIFont.NotoBold16
        lb.textColor = .black900
        return lb
    }()
    
    let foldButton : UIButton = {
        let bt = UIButton()
        bt.setDimensions(width: 24, height: 24)
        bt.setImage(UIImage(named: "arrow_bottom"), for: .normal)
        return bt
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(checkBoxButton)
        contentView.addSubview(agreeLabel)
        contentView.addSubview(foldButton)
        
        
        checkBoxButton.anchor(top:topAnchor,left: leftAnchor,paddingTop:27 ,paddingLeft:32)
        agreeLabel.anchor(top:topAnchor,left: checkBoxButton.rightAnchor,paddingTop:24 ,paddingLeft: 4)
        foldButton.anchor(top:topAnchor,left: agreeLabel.rightAnchor,paddingTop: 25,paddingLeft: 4)
        contentView.setDimensions(width: frame.width, height: 64)
        
        
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
