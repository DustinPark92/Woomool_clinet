//
//  ManagementTableViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/09/12.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class ManagementTableViewCell: UITableViewCell {
    
    let cafeNameLabel : UILabel = {
        let lb = UILabel()
        lb.text = "카페 알파카"
        lb.font = UIFont.NotoMedium20
        lb.textColor = .black900
        lb.textAlignment = .center
        return lb
    }()
    
    let cafeAdressLabel : UILabel = {
        let lb = UILabel()
        lb.text = "서울 광진구 능동로 200"
        lb.font = UIFont.NotoMedium14
        lb.textColor = .black400
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(cafeNameLabel)
        addSubview(cafeAdressLabel)
        
        cafeNameLabel.anchor(top:topAnchor,left: leftAnchor,paddingTop:24 ,paddingLeft:24.5 )
        
        cafeAdressLabel.anchor(top:cafeNameLabel.bottomAnchor,left: leftAnchor,bottom: bottomAnchor,paddingTop: 4,paddingLeft: 24.5,paddingBottom: 18)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()

        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
