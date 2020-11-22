//
//  BestWoomoolTableViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/09/07.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class BestWoomoolTableViewCell: UITableViewCell {
    
    let rankLabel : UILabel = {
        let lb = UILabel()
        lb.text = "1st"
        lb.textColor = .blue500
        lb.font = UIFont.RobotoBold16
        lb.textAlignment = .center
        return lb
    }()
    
    let storeNameLabel : UILabel = {
        let lb = UILabel()
        lb.text = "카페 알파카"
        lb.textColor = .black900
        lb.font = UIFont.NotoMedium14
        return lb
    }()
    
    let bestWoomoolIconImg : UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 18, height: 18)
        iv.image = UIImage(named: "icon_bestWoomool")
        return iv
    }()
    
    let bestWoomoolRating : UILabel = {
        let lb = UILabel()
        lb.text = "5.0"
        lb.textColor = .black400
        lb.font = UIFont.RobotoRegular14
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(rankLabel)
        addSubview(storeNameLabel)
        let stack = UIStackView(arrangedSubviews: [bestWoomoolIconImg,bestWoomoolRating])
        
        stack.axis = .horizontal
        stack.spacing = 6
        
        addSubview(stack)
        rankLabel.anchor(top:topAnchor,left:leftAnchor ,paddingTop: 11,paddingLeft: 14)
        storeNameLabel.anchor(top:topAnchor,left: rankLabel.rightAnchor,paddingTop:10 ,paddingLeft:8 )
        stack.anchor(top:topAnchor,right: rightAnchor,paddingTop: 14,paddingRight:17 )
        
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
