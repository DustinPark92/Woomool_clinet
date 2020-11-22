
//
//  EventTableViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/09/06.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
        lazy var dateLabel : UILabel = {
            let lb = UILabel()
            lb.text = "2020.08.01"
            lb.font = UIFont.NotoMedium12
            lb.textColor = UIColor.black400
            return lb
        }()
        
        lazy var titleLabel : UILabel = {
            let lb = UILabel()
            lb.text = "8월 매주 금요일은? 우물 플랙스데이! 우물 이용권쓰고 디저트 할인받자!"
            lb.font = UIFont.NotoMedium16
            lb.textColor = UIColor.black900
            lb.numberOfLines = 0
           return lb
        }()
    let progressLabel : UILabel = {
        let lb = UILabel()
        lb.text = "진행중"
        lb.textColor = .white
        lb.backgroundColor = .blue300
        lb.textAlignment = .center
        lb.setDimensions(width: 48, height: 48)
        lb.makeAcircle(dimension: 48)
        return lb
    }()
        
    
    
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            addSubview(dateLabel)
            addSubview(titleLabel)
            addSubview(progressLabel)
            
            
            dateLabel.anchor(top:topAnchor,left: leftAnchor,paddingTop: 16,paddingLeft: 32)
            titleLabel.anchor(top:dateLabel.bottomAnchor,left: leftAnchor,paddingTop: 2,paddingLeft: 32)
            
            progressLabel.anchor(top:topAnchor,left: titleLabel.rightAnchor,bottom: bottomAnchor,right: rightAnchor,paddingTop:36 ,paddingLeft: 5 ,paddingBottom:16 ,paddingRight:32)
            
            
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

