//
//  MyAreaDetailTableViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/09/10.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class MyAreaDetailTableViewCell: UITableViewCell {
    
    
    
    
    lazy var adressLabel : UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.black400
        lb.font = UIFont.NotoMedium14
        lb.text = "서울 광진구 능동로 200"
        return lb
    }()
    lazy var cafeNameLabel : UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.black900
        lb.font = UIFont.NotoMedium20
        lb.text = "카페 알파카"
        return lb
    }()
    lazy var distanceLabel : UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.blue500
        lb.font = UIFont.NotoMedium14
        lb.text = "2M"
        return lb
    }()
    
    let newImageView : UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 24, height: 24)
        iv.image = UIImage(named: "icon_newWoomool")
        return iv
    }()
    let bestImageView : UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 24, height: 24)
        iv.image = UIImage(named: "icon_bestWoomool")
        return iv
    }()
    
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(cafeNameLabel)
        addSubview(adressLabel)
        addSubview(distanceLabel)
        addSubview(newImageView)
        addSubview(bestImageView)
        
        
        cafeNameLabel.anchor(top:topAnchor,left: leftAnchor,paddingLeft: 24)
        bestImageView.anchor(top:topAnchor,right: rightAnchor,paddingTop: 16.5,paddingRight: 24)
        newImageView.anchor(top:topAnchor,right: bestImageView.leftAnchor,paddingTop: 16.5,paddingRight: 8)
        distanceLabel.anchor(top:topAnchor,left: cafeNameLabel.rightAnchor,right: newImageView.leftAnchor,paddingTop:8,paddingLeft: 8,paddingRight: 8)
        adressLabel.anchor(top:cafeNameLabel.bottomAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor,paddingTop: 4,paddingLeft: 24,paddingBottom: 18,paddingRight: 24)
        
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
