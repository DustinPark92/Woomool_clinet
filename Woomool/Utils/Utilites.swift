//
//  Utilites.swift
//  Woomool
//
//  Created by Dustin on 2020/12/05.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit


enum singleAlertContent : Int , CaseIterable {
    case woomoolService
    case woomoolManagement
    case userChangePassComplete
    case noWoomoolGoods
    

    var contentTitle : String {
        switch self {
        case .woomoolService:
            return "우물 서비스 요청이\n접수되었습니다."
        case .woomoolManagement:
            return "수질관리 요청이\n접수되었습니다."
        case .userChangePassComplete:
            return "비밀번호 변경이\n완료되었습니다."
        case .noWoomoolGoods:
            return "먼저 우물 이용권을\n 구매해주세요."
        }
        
    }
}


enum twoAlertContent : Int , CaseIterable {
    case userLogOut
    case userDelete
    case userPhoneChange

    
    var contentTitle : String {
        switch self {
        case .userLogOut:
            return "로그아웃 할까요?"
        case .userDelete:
            return "우물을 탈퇴하시고\n모든 정보를\n삭제하시겠습니까?"
        case .userPhoneChange:
            return "휴대폰 번호 변경을 위해\n본인인증 페이지로\n이동합니다."
        }
        
    }
}


class Utilites {
    
    
    func customOKAlert(text : String, button : UIButton) -> UIView {
  
        let view = UIView()
        let mainLabel = UILabel()
        
        
        mainLabel.font = UIFont.NotoMedium20
        mainLabel.textColor = .black900
        mainLabel.text = text
        mainLabel.numberOfLines = 0
        
        
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.NotoBold18
        button.backgroundColor = .blue500
        
        view.addSubview(mainLabel)
        view.addSubview(button)
        view.backgroundColor = .white
        view.makeAborder(radius: 14)
        
        mainLabel.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: 107)
        
        button.anchor(left:view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,height: 56)
        return view
    }
    
    
    func customTwoButtonAlert(text : String, confirmButton : UIButton, cancelButton : UIButton) -> UIView {
  
        let view = UIView()
        let mainLabel = UILabel()
        
        
        mainLabel.font = UIFont.NotoMedium20
        mainLabel.textColor = .black900
        mainLabel.text = text
        mainLabel.numberOfLines = 0
        
        
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.titleLabel?.font = UIFont.NotoBold18
        confirmButton.backgroundColor = .blue500
        
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.gray400, for: .normal)
        cancelButton.titleLabel?.font = UIFont.NotoBold18
        cancelButton.backgroundColor = .gray300
        
        let stack = UIStackView(arrangedSubviews: [cancelButton,confirmButton])
        view.addSubview(stack)
        view.addSubview(mainLabel)

        view.backgroundColor = .white
        view.makeAborder(radius: 14)
        
        mainLabel.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: 50)
        
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.anchor(left:view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,height: 56)

        return view
    }
    
    
    
    func inputContainerView(textField: UITextField,description : String,requiredText : String,warningLabel : UILabel ,warningColor : UIColor ) -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let descriptionLabel = UILabel()
        
        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top:view.topAnchor,left: view.leftAnchor,paddingLeft: 8)
        descriptionLabel.text = description
        descriptionLabel.font = UIFont.NotoBold16
        
        
        let requiredLabel = UILabel()
        view.addSubview(requiredLabel)
        requiredLabel.text = requiredText
        requiredLabel.textColor = .blue500
        requiredLabel.font = UIFont.NotoBold16
        requiredLabel.anchor(top:view.topAnchor,left: descriptionLabel.rightAnchor,paddingRight: 1)
        
        
        view.addSubview(textField)
        textField.anchor(top:descriptionLabel.bottomAnchor,left: view.leftAnchor,right:view.rightAnchor,paddingTop: 6,paddingLeft: 8,paddingBottom: 6)
        textField.setDimensions(width: 24, height: 30)
        textField.textColor = .black900
        textField.font = UIFont.NotoBold16
        
        
        let sv = UIView()
        view.addSubview(sv)
        sv.backgroundColor = .gray300
        sv.anchor(top:textField.bottomAnchor,left:view.leftAnchor,right:view.rightAnchor,paddingTop: 6,paddingLeft:8,height: 2)
        
        
        warningLabel.textColor = warningColor
        
        view.addSubview(warningLabel)
        warningLabel.anchor(top:sv.bottomAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,paddingTop: 10,paddingRight: 16)
        
        return view
    }
    
    func inputContainerGenderView(manButton : UIButton,womanButton: UIButton,description : String) -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let descriptionLabel = UILabel()
        
        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top:view.topAnchor,left: view.leftAnchor,paddingLeft: 8)
        descriptionLabel.text = description
        descriptionLabel.font = UIFont.NotoBold16
        
        let stack = UIStackView(arrangedSubviews: [manButton,womanButton])
        view.addSubview(stack)
        stack.anchor(top:descriptionLabel.bottomAnchor,left: view.leftAnchor,paddingTop:6 ,paddingLeft: 15)
        stack.axis = .horizontal
        stack.spacing = 36
        
     
        
        let sv = UIView()
        view.addSubview(sv)
        sv.backgroundColor = .gray300
        sv.anchor(top:stack.bottomAnchor,left:view.leftAnchor,right:view.rightAnchor,paddingTop: 6,paddingLeft:8,height: 2)
        
        return view
    }
    
    
    func checkBoxButton(inputText text : String) -> UIButton {
        let bt = UIButton(type: .custom)
        bt.setTitle(text, for: .normal)
        bt.setTitleColor(.black, for: .normal)
        bt.titleLabel?.font = UIFont.NotoBold16
        
        bt.setImage(UIImage(named: "inactiveGender"), for: .normal)
        bt.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        
        return bt
    }
    func textField(placeholder : String) -> UITextField {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray350,NSAttributedString.Key.font : UIFont.NotoRegular16!])
        
        
        return tf
    }
    
//    func textField() -> UITextField {
//        let tf = UITextField()
//        tf.attributedPlaceholder = NSAttributedString(string: , attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray350,NSAttributedString.Key.font : UIFont.NotoRegular16!])
//
//
//        return tf
//    }
//
    
    
}
