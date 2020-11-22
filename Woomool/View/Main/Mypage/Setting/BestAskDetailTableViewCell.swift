//
//  BestAskDetailTableViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/09/07.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class BestAskDetailTableViewCell: UITableViewCell {
    let qLabel : UILabel = {
        let lb = UILabel()
        lb.text = "Q"
        lb.font = UIFont.NotoRegular16
        lb.textColor = .blue500
        return lb
    }()
    
    let questionLabel : UILabel = {
        let lb = UILabel()
        lb.text = "위치정보 이용의 동의 및 해제는 어떻게 하나요?"
        lb.font = UIFont.NotoRegular16
        lb.textColor = .black900
        lb.numberOfLines = 0 
        return lb
    }()
    
    let foldButotn : UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "top_arrow"), for: .normal)
        bt.setDimensions(width: 24, height: 24)
        return bt
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(qLabel)
        addSubview(questionLabel)
        addSubview(foldButotn)
        
        
        qLabel.anchor(top:topAnchor,left:leftAnchor,paddingTop:16 ,paddingLeft: 32)
        questionLabel.anchor(top:topAnchor,left: qLabel.rightAnchor,bottom: bottomAnchor,paddingTop: 16,paddingLeft: 6,paddingBottom: 16)
        foldButotn.anchor(top:topAnchor,right:rightAnchor,paddingTop:16 ,paddingRight: 32)
    
        
        
        
        
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
