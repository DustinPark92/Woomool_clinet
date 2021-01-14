//
//  PrivateAuthView.swift
//  Woomool
//
//  Created by Dustin on 2020/11/24.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class PrivateAuthView: UIView {
    
    let logoImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.setDimensions(width: 120, height: 15)
        iv.image = UIImage(named: "logo_navbar")
       
        return iv
    }()
    
    let sv1 = UIView()
    
    let allAgreeButton : UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "check_inactive"), for: .normal)
        bt.setDimensions(width: 18, height: 18)
        return bt
    }()
    
    let allAgreeLabel : UILabel = {
        let lb = UILabel()
        lb.text = "전체 동의 하기"
        lb.font = UIFont.NotoMedium14
        lb.textColor = .black900
        return lb
    }()
    
    let allagreeContentsLabel : UILabel = {
        let lb = UILabel()
        lb.text = "전체 동의는 선택목적에 대한 동의를 포함하고 있으며, \n선택목적에 대한 동의를 거부해도 서비스 이용이 가능합니다."
        lb.numberOfLines = 2
        lb.textAlignment = .left
        lb.font = UIFont.NotoMedium12
        lb.textColor = .black400
        return lb
    }()

    

    
    let sv2 = UIView()
    
    let tableView = UITableView()
    
    
    let confirmButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("동의하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray300
        button.titleLabel?.font = UIFont.NotoBold18
        
        return button
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeAborder(radius: 14)
        
        addSubview(logoImageView)
        logoImageView.centerX(inView: self, topAnchor: topAnchor, paddingTop: 16)
        addSubview(sv1)
        sv1.anchor(top:logoImageView.bottomAnchor,left: leftAnchor,right: rightAnchor,paddingTop:15 ,paddingLeft: 8,paddingRight: 8,height: 1)
        sv1.backgroundColor = .gray200
        
        addSubview(allAgreeButton)
        allAgreeButton.anchor(top:sv1.bottomAnchor,left: leftAnchor,paddingTop: 20,paddingLeft: 12)
        
        addSubview(allAgreeLabel)
        allAgreeLabel.anchor(top:sv1.bottomAnchor,left: allAgreeButton.rightAnchor,paddingTop: 12,paddingLeft : 5)
        
        addSubview(allagreeContentsLabel)
        allagreeContentsLabel.anchor(top:allAgreeLabel.bottomAnchor,left: leftAnchor,right: rightAnchor,paddingTop: 3 ,paddingLeft: 35,paddingRight: 12)
        
        addSubview(sv2)
        sv2.anchor(top:allagreeContentsLabel.bottomAnchor,left: leftAnchor,right: rightAnchor,paddingTop:8 ,paddingLeft: 8,paddingRight: 8,height: 1)
        sv2.backgroundColor = .gray200
        
        
        addSubview(tableView)
        tableView.anchor(top: sv2.bottomAnchor,left: leftAnchor,right: rightAnchor,height: 202)
        
        
        addSubview(confirmButton)
        confirmButton.anchor(top:tableView.bottomAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor,height: 56)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
 

}

