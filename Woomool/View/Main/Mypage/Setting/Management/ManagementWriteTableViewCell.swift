//
//  ManagementWriteTableViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/09/12.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class ManagementWriteTableViewCell: UITableViewCell {
    
    let textView = UITextView()
    
    let seperaterView : UIView = {
     let uv = UIView()
        uv.backgroundColor = .bestAsk
        return uv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textView)
        contentView.addSubview(seperaterView)
        seperaterView.anchor(top:topAnchor,left: leftAnchor,right: rightAnchor,width: frame.width,height: 8)
        textView.anchor(top:seperaterView.bottomAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor,paddingTop:16,paddingLeft: 24,paddingRight: 24)
        

        
        
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
