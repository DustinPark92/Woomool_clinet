//
//  SocialLoginAdditionalDataCell.swift
//  Woomool
//
//  Created by Dustin on 2021/01/02.
//  Copyright © 2021 Woomool. All rights reserved.
//

import UIKit

class SocialLoginAdditionalDataCell: UITableViewCell {
    
    lazy var nameContainer = Utilites().inputContainerView(textField: nameTextField, description: "이름", requiredText: "*",warningLabel: nameWarningLabel,warningColor: .red)
    let nameTextField = Utilites().textField(placeholder: "2자 이상의 실명을 입력해주세요. ex) 홍길동")
    let nameWarningLabel = UILabel()
    
    lazy var birthContainer = Utilites().inputContainerView(textField: birthTextField, description: "생년월일", requiredText: "*",warningLabel: birthWarningLabel,warningColor: .red)
    let birthTextField = Utilites().textField(placeholder: "8자리 입력 ex)YYYYMMDD.")
    let birthWarningLabel = UILabel()
    
    lazy var genderContainer = Utilites().inputContainerGenderView(manButton: manButton, womanButton: womanButton, description: "성별")
    
    let manButton = Utilites().checkBoxButton(inputText: "남")
    let womanButton = Utilites().checkBoxButton(inputText: "여")
    
    
    
    lazy var inviteCodeContainer = Utilites().inputContainerView(textField: inviteTextField, description: "초대코드", requiredText: "",warningLabel: inviteWarningLabel,warningColor: .gray350)
    let inviteTextField = Utilites().textField(placeholder: "초대코드를 입력해주세요.")
    let inviteWarningLabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(nameContainer)
        nameContainer.anchor(top:topAnchor,left: leftAnchor,right: rightAnchor,paddingTop: 24,paddingLeft: 16,paddingRight: 16,height: 90)
        
        contentView.addSubview(birthContainer)
        birthContainer.anchor(top:nameContainer.bottomAnchor,left: leftAnchor,right: rightAnchor,paddingTop:48 ,paddingLeft: 16,paddingRight:16 ,height: 90)
        
        contentView.addSubview(genderContainer)
        genderContainer.anchor(top:birthContainer.bottomAnchor,left: leftAnchor,right: rightAnchor,paddingTop:48 ,paddingLeft: 16,paddingRight:16 ,height: 62)
        
        
        contentView.addSubview(inviteCodeContainer)
        inviteCodeContainer.anchor(top:genderContainer.bottomAnchor,left: leftAnchor,right: rightAnchor,paddingTop:48 ,paddingLeft: 16,paddingRight:16 ,height: 90)
        inviteWarningLabel.text = "초대 코드를 받아 가입시 우물 이용권을 드립니다."

        
        
        
        
        
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
