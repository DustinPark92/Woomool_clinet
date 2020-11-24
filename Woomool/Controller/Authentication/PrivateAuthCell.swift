//
//  PrivateAuthCell.swift
//  Woomool
//
//  Created by Dustin on 2020/11/24.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class PrivateAuthCell: UITableViewCell {
    
    let checkBoxButton : UIButton = {
        let bt = UIButton()
        bt.setDimensions(width: 18, height: 18)
        bt.setImage(UIImage(named: "list_check_inactive"), for: .normal)
        return bt
    }()
    
    let mainLabel : UILabel = {
        let lb = UILabel()
        lb.text = "[필수] 서비스 이용약관"
        lb.font = UIFont.NotoMedium12
        lb.textColor = .black400
        
        return lb
    }()
    
    let detailButton : UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "보기", attributes: [NSAttributedString.Key.font :UIFont.NotoMedium12!,NSAttributedString.Key.foregroundColor: UIColor.black400])
        attributedTitle.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, "보기".count))
        
        
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        
        return button
    }()
    
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(checkBoxButton)
        contentView.addSubview(mainLabel)
        contentView.addSubview(detailButton)
        checkBoxButton.anchor(top:topAnchor,left: leftAnchor,paddingTop: 12,paddingLeft: 8)
        mainLabel.anchor(top:topAnchor,left: checkBoxButton.rightAnchor,paddingTop:12,paddingLeft: 4,height: 18)
        detailButton.anchor(top:topAnchor,right: rightAnchor,paddingTop: 12,paddingRight: 8,height: 18)
        
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
