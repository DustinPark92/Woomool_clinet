//
//  BestAskDetailContentsTableViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/09/07.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class BestAskDetailContentsTableViewCell: UITableViewCell {
    let titleLabel : UILabel = {
        let lb = UILabel()
        lb.text = "1. 위치 정보 이용에 동의하시려면?"
        lb.font = UIFont.NotoRegular16
        lb.textColor = .black900
        lb.numberOfLines = 0
        return lb
    }()
    
    let contentLabel : UILabel = {
        let lb = UILabel()
        lb.text = "우물 가입시 동의하시거나, 우물의 위치기반 서비스를 시작할 때 위치정보 수집 및 이용동의 약관이 보여집니다. 내 근처우물에서 현재위치 중심의 결과를 보고자 하실 때 위치 정보 이용 동의를 하실 수 있습니다."
        lb.font = UIFont.NotoRegular16
        lb.textColor = .black900
        lb.setLineSpacing(lineSpacing: 24, lineHeightMultiple: 0)
        lb.numberOfLines = 0
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .bestAsk
        addSubview(titleLabel)
        addSubview(contentLabel)
        
        titleLabel.anchor(top:topAnchor,left: leftAnchor,right: rightAnchor,paddingTop: 16,paddingLeft: 32,paddingRight: 32)
        contentLabel.anchor(top:titleLabel.bottomAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor,paddingTop: 5,paddingLeft: 32,paddingBottom: 24,paddingRight: 32)
        
        
        
        
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
