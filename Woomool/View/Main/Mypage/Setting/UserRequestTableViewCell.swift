//
//  UserRequestTableViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/09/06.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class UserRequestTableViewCell: UITableViewCell {
    
    var option: UserRequestOption! {
        didSet { titleLabel.text = option.description }
    }
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black900
        label.font = UIFont.NotoRegular16
        
        return label
    }()
    
    let nextButton : UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "right_arrow"), for: .normal)
        bt.setDimensions(width: 24, height: 24)
        return bt
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titleLabel)
        addSubview(nextButton)
        titleLabel.anchor(top:topAnchor,left: leftAnchor,paddingTop: 20,paddingLeft: 32)
        nextButton.anchor(top:topAnchor,right: rightAnchor,paddingTop: 20,paddingRight: 32)
        
        
        
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
