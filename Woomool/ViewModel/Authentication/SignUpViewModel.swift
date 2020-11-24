//
//  SignUpViewModel.swift
//  Woomool
//
//  Created by Dustin on 2020/08/26.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit


class SignUpViewModel {
    
    var emailValid = false
    var passValid = false
    var passCheckValid = false
    var nickNameValid = false
    var recomdValid = false
    
    var subjectList = ["이메일"]
    var placeholderList = ["이메일@naver.com"]
    var textFieldContents = ["이메일","비밀번호","비밀번호 확인","닉네임","추천코드"]
    var viewUpSize = [0,0,0,120,150]
    var textFieldSecure = [false]
    var warningMessage = ["비밀번호 찾기를 위해 수신 가능한 이메일을 입력해주세요."]
    var invalidMessage = [""]
    var warningColor : [UIColor] = [.gray350]
    var svBackgroundColor : [UIColor] = [.gray300,.gray300,.gray300,.gray300,.gray300]
    



    
    
    
    
    
    func ValidCheck(at number : Int, to content : String){
        textFieldContents.remove(at: number)
        textFieldContents.insert(content, at: number)
        
    }
    
    func validwithSwitch(tag : Int , text : String, testCode : String ) {
        switch subjectList.count {
        case 1 + tag:
            if (text.isValidEmailAddress(email: text)){
                ValidCheck(at: 0, to: text)
                emailValid = true
                print("내용은 \(textFieldContents)")
            } else {
                ValidCheck(at: 0, to: "이메일")
                emailValid = false
                print("내용은 \(textFieldContents)")
            }
        case 2 + tag:
            if (text.validatePassword()) {
                ValidCheck(at: 1, to: text)
                passValid = true
                print("내용은 \(textFieldContents)")
            } else {
                ValidCheck(at: 1, to: "비밀번호")
                passValid = false
                print("내용은 \(textFieldContents)")
            }
        case 3 + tag:
            if (text.validatePassword()) && text == textFieldContents[1] {
                ValidCheck(at: 2, to: text)
                passCheckValid = true
                print("내용은 \(textFieldContents)")
            } else {
                ValidCheck(at: 2, to: "비밀번호확인")
                passCheckValid = false
                print("내용은 \(textFieldContents)")
            }
        case 4 + tag:
            if text.count < 8 {
                ValidCheck(at: 3, to: text)
                nickNameValid = true
                print("내용은 \(textFieldContents)")
            } else {
                ValidCheck(at: 3, to: "닉네임")
                nickNameValid = false
                print("내용은 \(textFieldContents)")
            }
            
        case 5 + tag:
            if testCode == text {
                ValidCheck(at: 4, to: text)
                recomdValid = true
            } else {
                ValidCheck(at: 5, to: text)
            }
        default:
            break
        }
    }
    
    
    
    
    
    
    func inputContainerView(textField: UITextField,label : UILabel, sv : UIView) -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        view.addSubview(textField)
        textField.anchor(top:view.topAnchor,left: view.leftAnchor,right:view.rightAnchor,paddingLeft: 8,paddingBottom: 6)
        textField.setDimensions(width: 24, height: 30)
        textField.textColor = .black900
        textField.font = UIFont.NotoBold16
        
        
        
        view.addSubview(sv)
        
        
        
        sv.backgroundColor = .gray300
        sv.anchor(top:textField.bottomAnchor,left:view.leftAnchor,right:view.rightAnchor,paddingTop: 6,paddingLeft:8,height: 2)
        
        
        view.addSubview(label)
        label.anchor(top:sv.bottomAnchor,left:view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,paddingTop: 10,paddingLeft: 8)
        
        return view
    }
    
    func textField() -> UITextField {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: placeholderList[0], attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray350,NSAttributedString.Key.font : UIFont.NotoRegular16!])
        
        
        return tf
    }
    
    func Label() -> UILabel {
        let lb = UILabel()
        lb.textColor = warningColor[0]
        lb.text = warningMessage[0]
        lb.font = UIFont.systemFont(ofSize: 10)
        return lb
    }
    
    func popUpView(naverButton : UIButton, googleButton : UIButton, kakaoButton : UIButton, appleButton : UIButton , emailButton : UIButton , mainLabel : UILabel, subLabel : UILabel, findPassButton : UIButton , signUpButton : UIButton, sv : UIView) -> UIView {
        
        let view = UIView()
        view.backgroundColor = .white
        view.makeAborder(radius: 5)
        
        view.addSubview(naverButton)
        view.addSubview(googleButton)
        view.addSubview(kakaoButton)
        view.addSubview(appleButton)
        view.addSubview(emailButton)
        view.addSubview(mainLabel)
        view.addSubview(subLabel)
        
        

        
        
        mainLabel.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: 45)
        emailButton.centerX(inView: view, topAnchor: mainLabel.bottomAnchor, paddingTop: 53)
        emailButton.setDimensions(width: 300, height: 56)
        subLabel.centerX(inView: view, topAnchor: emailButton.bottomAnchor, paddingTop: 36)
        
        
        let stack = UIStackView(arrangedSubviews: [googleButton,kakaoButton,naverButton,appleButton])
        
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.spacing = 16
        view.addSubview(stack)
        
        stack.centerX(inView: view, topAnchor: subLabel.bottomAnchor, paddingTop: 16)
        

        sv.setDimensions(width: 0.5, height: 16)
        sv.backgroundColor = .black400
        
        let stackBottom = UIStackView(arrangedSubviews: [findPassButton,sv,signUpButton])
        stackBottom.axis = .horizontal
        stackBottom.spacing = 10
        view.addSubview(stackBottom)
        stackBottom.centerX(inView: view, topAnchor: stack.bottomAnchor, paddingTop: 40)
        
        
        
        
        
        
        return view
    }
    
    func privatePopUpView(allAgreeButton : UIButton, serviceButton : UIButton, privateInfoButton : UIButton, locationButton : UIButton, marketingButton : UIButton , emailButton : UIButton , smsButton : UIButton , pushButton : UIButton, serviceDetail : UIButton , privateDetail : UIButton , locationDetail : UIButton, comfirmButton : UIButton) -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.makeAborder(radius: 5)
        let logoImage = UIImageView()
        logoImage.contentMode = .scaleAspectFit
        logoImage.setDimensions(width: 120, height: 15)
        logoImage.image = UIImage(named: "logo_navbar")
        view.addSubview(logoImage)
        logoImage.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: 16)
        
        let svTop = UIView()
        view.addSubview(svTop)
        svTop.setDimensions(width: 360, height: 1)
        svTop.backgroundColor = .gray200
        svTop.centerX(inView: view, topAnchor: logoImage.bottomAnchor, paddingTop: 15)
        
        view.addSubview(allAgreeButton)
        allAgreeButton.anchor(top:svTop.bottomAnchor,left: view.leftAnchor,paddingTop: 16,paddingLeft: 12)
        
        let allAgreeLabel = UILabel()
        allAgreeLabel.text = "전체 동의"
        allAgreeLabel.font = UIFont.NotoMedium14
        allAgreeLabel.textColor = .black900
        view.addSubview(allAgreeLabel)
        allAgreeLabel.anchor(top:svTop.bottomAnchor,left: allAgreeButton.rightAnchor,paddingTop: 12,paddingLeft : 5)
        
        let allagreeContentsLabel = UILabel()
        allagreeContentsLabel.text = "전체 동의는 선택목적에 대한 동의를 포함하고 있으며, \n선택목적에 대한 동의를 거부해도 서비스 이용이 가능합니다."
        allagreeContentsLabel.numberOfLines = 2
        allagreeContentsLabel.textAlignment = .left
        allagreeContentsLabel.font = UIFont.NotoMedium12
        allagreeContentsLabel.textColor = .black400
        view.addSubview(allagreeContentsLabel)
        allagreeContentsLabel.anchor(top:allAgreeLabel.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 3  ,paddingLeft: 35,paddingRight: 12)
        
        let svBottom = UIView()
        view.addSubview(svBottom)
        svBottom.setDimensions(width: 360, height: 1)
        svBottom.backgroundColor = .gray200
        svBottom.centerX(inView: view, topAnchor: allagreeContentsLabel.bottomAnchor, paddingTop: 12)
        

        
        view.addSubview(comfirmButton)
        comfirmButton.anchor(left:view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,height: 56)
        
        
        
        
        
        return view
    }
    
    func allAgreeButton() -> UIButton {
        let button = UIButton()
        button.setDimensions(width: 18, height: 18)
        button.setImage(UIImage(named: "check_inactive"), for: .normal)
        return button
    }
    
    func listButton(setTitle : String? = nil) -> UIButton {
        let button = UIButton()
        button.setDimensions(width: 18, height: 18)
        button.setImage(UIImage(named: "list_check_inactive"), for: .normal)
        button.setTitle(setTitle, for: .normal)
        return button
    }
    
    func listLabel(title : String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.NotoMedium12
        label.textColor = .black400
        label.text = title
        return label
    }
    
    func attributedButton(_ firstPart: String) -> UIButton {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: firstPart, attributes: [NSAttributedString.Key.font :UIFont.NotoMedium12!,NSAttributedString.Key.foregroundColor: UIColor.black400])
        attributedTitle.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, firstPart.count))
               
     
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        
        return button
    }
    
    
    func buttonUI(setTitle title: String) -> UIButton {
        
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue500
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.NotoBold18
        
        return button
    }
    
    func labelUI(setTitle title: String , setFont font: UIFont , setColor color : UIColor) -> UILabel {
        let label = UILabel()
        label.textColor = color
        label.font = font
        label.text = title
        return label
    }
    
    func oAuthButton(setImage : UIImage) -> UIButton {
        let button = UIButton()
        button.setDimensions(width: 60, height: 60)
        button.makeAcircle(dimension: 60)
        button.setImage(setImage, for: .normal)
        return button
    }
    
    
    
    
}
