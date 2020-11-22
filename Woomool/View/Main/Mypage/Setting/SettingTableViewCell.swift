//
//  SettingTableViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/09/06.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    let mainLabel : UILabel = {
        let lb = UILabel()
        lb.font = UIFont.NotoRegular16
        lb.textAlignment = .center
        lb.textColor = .black900
        return lb
    }()
    
    let toggleSwitch : UISwitch = {
        let sw = UISwitch()
        sw.onTintColor = .blue500
        return sw
    }()
    
    let versionLabel : UILabel = {
        let lb = UILabel()
        lb.text = "1.0.0 최신 버전"
        lb.textColor = .black400
        lb.font = UIFont.NotoRegular16
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(mainLabel)
        addSubview(toggleSwitch)
        addSubview(versionLabel)
        
        mainLabel.anchor(top:topAnchor,left: leftAnchor,paddingTop:16.3 ,paddingLeft:32 )
        
        toggleSwitch.isHidden = true
        versionLabel.isHidden = true
        toggleSwitch.anchor(top:topAnchor,right: rightAnchor,paddingTop: 17,paddingRight: 32)
        versionLabel.anchor(top:topAnchor,right: rightAnchor,paddingTop:13.3 ,paddingRight:31.95 )
        
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
