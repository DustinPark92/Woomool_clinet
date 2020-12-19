//
//  HistoryTableViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/09/08.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    let typeImg : UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 48, height: 48)
        iv.makeAcircle(dimension: 48)
        iv.image = UIImage(named: "icon_use")
        return iv
    }()
    
    let nameLabel : UILabel = {
        let lb = UILabel()
        lb.text = "우물 사용"
        lb.font = UIFont.NotoMedium14
        lb.textColor = .black
        return lb
    }()
    
    let extraLabel : UILabel = {
        let lb = UILabel()
        lb.font = UIFont.NotoMedium14
        lb.textColor = .black400
        return lb
    }()
    
    let countPriceLabel : UILabel = {
        let lb = UILabel()
        lb.text = "카페 알파카"
        lb.font = UIFont.NotoMedium14
        lb.textColor = .black
        return lb
    }()
    
    let dateLabel : UILabel = {
        let lb = UILabel()
        lb.text = "2020/08/02"
        lb.font = UIFont.NotoMedium14
        lb.textColor = .black400
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(typeImg)
        addSubview(nameLabel)
        addSubview(extraLabel)
        addSubview(countPriceLabel)
        addSubview(dateLabel)
        
        typeImg.anchor(top:topAnchor,left: leftAnchor,paddingTop: 16,paddingLeft: 24)
        nameLabel.anchor(top:topAnchor,left: typeImg.rightAnchor,paddingTop:15 ,paddingLeft:8)
        extraLabel.anchor(top:nameLabel.bottomAnchor,left: typeImg.rightAnchor,bottom: bottomAnchor,paddingTop:2 ,paddingLeft:8,paddingBottom: 19)
        countPriceLabel.anchor(top:topAnchor,right: rightAnchor,paddingTop:15 ,paddingRight:32)
        dateLabel.anchor(top:countPriceLabel.bottomAnchor,bottom:bottomAnchor,right:rightAnchor,paddingTop:1.38,paddingBottom: 18.62,paddingRight: 32)
        
        
        
        
        
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
