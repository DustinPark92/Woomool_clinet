//
//  ManagementHeaderView.swift
//  Woomool
//
//  Created by Dustin on 2020/09/12.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class ManagementHeaderView: UIView {
    
    let viewModel = ManagementViewModel()
    
    let mainLabel : UILabel = {
        let lb = UILabel()
        lb.text = "더 나은 우물 서비스 이용을 위해 수질 관리 요청을 받고 있습니다. \n 모든 내용은 익명으로 처리됩니다."
        lb.font = UIFont.NotoMedium12
        lb.textColor = .black400
        lb.textAlignment = .center
        lb.numberOfLines = 0 
        return lb
    }()
    
    
    let searchBarLabel : UILabel = {
        let lb = UILabel()
        lb.text = "가맹점 선택"
        lb.font = UIFont.NotoRegular16
        lb.textColor = .black
        return lb
    }()
    
    lazy var searchContainerView : UIView = viewModel.inputContainerView(textField: textField)
    
    lazy var textField : UITextField = viewModel.textField(placeholder: "가맹점 이름을 입력하세요.")
    
    let cancelButton : UIButton = {
        let bt = UIButton()
        bt.setTitle("취소", for: .normal)
        bt.setTitleColor(.black, for: .normal)
        return bt
    }()

    
    let btmSeperatorView : UIView = {
        let uv = UIView()
        uv.backgroundColor = .gray300
        return uv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mainLabel)
        addSubview(searchBarLabel)

        addSubview(btmSeperatorView)
        
        
        let stack = UIStackView(arrangedSubviews: [searchContainerView,cancelButton])
        stack.axis = .horizontal
        stack.spacing = 8
        addSubview(stack)
        cancelButton.isHidden = true
      
        mainLabel.centerX(inView: self, topAnchor: topAnchor, paddingTop: 24)
        searchBarLabel.anchor(top:mainLabel.bottomAnchor,left:leftAnchor,paddingTop: 24,paddingLeft: 35.4)
        
        stack.anchor(top:searchBarLabel.bottomAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor,paddingTop: 6,paddingLeft: 32,paddingBottom: 16,paddingRight: 32)
        
        
        btmSeperatorView.anchor(left:leftAnchor,bottom: bottomAnchor,right: rightAnchor,width: frame.width,height: 1)
        
        textField.clearButtonMode = .whileEditing
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
