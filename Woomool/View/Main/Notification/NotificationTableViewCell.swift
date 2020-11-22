//
//  NoticeTableViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/09/02.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    let color = UIColor()
    
    
    lazy var dateLabel : UILabel = {
        let lb = UILabel()
        lb.text = "2020.08.01"
        lb.font = UIFont.NotoMedium12
        lb.textColor = UIColor.black400
        return lb
    }()
    
    lazy var titleLabel : UILabel = {
        let lb = UILabel()
        lb.text = "계속되는 비로 꿉꿉해진 기분 상쾌하게 만들어줄 2.0.0 업데이트 안내"
        lb.font = UIFont.NotoMedium16
        lb.textColor = UIColor.black900
        lb.numberOfLines = 0
       return lb
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(dateLabel)
        addSubview(titleLabel)
        
        
        dateLabel.anchor(top:topAnchor,left: leftAnchor,paddingTop: 16,paddingLeft: 32)
        titleLabel.anchor(top:dateLabel.bottomAnchor,left: leftAnchor,right: rightAnchor,paddingTop: 2,paddingLeft: 32,paddingRight: 32)
        
        
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
