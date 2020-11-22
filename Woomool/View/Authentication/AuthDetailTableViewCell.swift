//
//  AuthDetailTableViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/10/30.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class AuthDetailTableViewCell: UITableViewCell {
    
     let mainLabel : UILabel = {
        let lb = UILabel()
        lb.font = UIFont.NotoMedium16
        lb.textColor = .black900
        lb.numberOfLines = 0 
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(mainLabel)
        mainLabel.anchor(top:topAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor,paddingTop:16 ,paddingLeft:32 ,paddingRight: 32)
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
