//
//  NoticeDetailTableViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/10/11.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class NoticeDetailTableViewCell: UITableViewCell {

    
    let contentLabel : UILabel = {
        let lb = UILabel()
        lb.text = "일리님 ‘카페 삼양여관’ 서비스이용신청이 접수되었습니다. 소중한 의견 감사합니다 :)"
        lb.font = UIFont.NotoRegular16
        lb.textColor = .black900
        lb.setLineSpacing(lineSpacing: 24, lineHeightMultiple: 0)
        lb.numberOfLines = 0
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .bestAsk
        addSubview(contentLabel)

        contentLabel.anchor(top:topAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor,paddingTop: 16,paddingLeft: 16,paddingBottom: 16,paddingRight: 16)
        
        
        
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
