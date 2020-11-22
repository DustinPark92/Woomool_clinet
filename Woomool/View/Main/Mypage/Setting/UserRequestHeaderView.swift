//
//  UserRequestHeaderView.swift
//  Woomool
//
//  Created by Dustin on 2020/09/06.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class UserRequestHeaderView: UIView {
    
    let viewModel = UserRequestViewModel()
    
    let kakaoButton : UIButton = {
        let bt = UIButton()
        bt.contentMode = .scaleAspectFit
        bt.setImage(UIImage(named: "sns_kakao"), for: .normal)
        bt.setDimensions(width: 60, height: 60)
        return bt
    }()
    lazy var kakaoStringAttributedButton = viewModel.attributedButton("카카오톡 문의하기")
    
    let requestTimeLabel : UILabel = {
        let lb = UILabel()
        lb.text = "문의 시간: 평일 오전 9:00 - 오후 6:00 \n 점심시간: 오전 11:30 - 오후 12:30 \n 주말,공휴일 휴무"
        lb.font = UIFont.NotoMedium14
        lb.numberOfLines = 3
        lb.textAlignment = .center
        lb.textColor = .black400
        return lb
    }()
    
    
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(kakaoButton)
        addSubview(kakaoStringAttributedButton)
        addSubview(requestTimeLabel)
        
        kakaoButton.centerX(inView: self, topAnchor: topAnchor, paddingTop: 89)
        kakaoStringAttributedButton.centerX(inView: self, topAnchor: kakaoButton.bottomAnchor, paddingTop: 12)
        requestTimeLabel.centerX(inView: self, topAnchor: kakaoStringAttributedButton.bottomAnchor, paddingTop: 34)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
