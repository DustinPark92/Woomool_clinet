//
//  PhoneAuthViewModel.swift
//  Woomool
//
//  Created by Dustin on 2020/09/14.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit


class PhoneAuthViewModel {
    
    
    var phoneAuthSend = false
    

    func containerViewWithButton(selectButton : UIButton, countryLabel : UILabel) -> UIView {
        let view = UIView()
        
        view.addSubview(selectButton)
        view.addSubview(countryLabel)
        
        countryLabel.anchor(top:view.topAnchor,left: view.leftAnchor)
        selectButton.anchor(top:view.topAnchor,left: view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor)
        
        let iv = UIImageView()
        view.addSubview(iv)
        iv.setDimensions(width: 24, height: 24)
        iv.anchor(top:view.topAnchor,right: view.rightAnchor)
        iv.image = UIImage(named: "arrow_bottom")
        let sv = UIView()
        view.addSubview(sv)
        sv.backgroundColor = .gray300
        sv.anchor(left:view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,width: view.frame.width,height: 2)

        return view
    }
    
    func containerViewTextField(textField : UITextField) -> UIView {
        let view = UIView()
        
        view.addSubview(textField)
        textField.anchor(top:view.topAnchor,left: view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,paddingBottom: 5)
        
        
        let sv = UIView()
        view.addSubview(sv)
        sv.backgroundColor = .gray300
        sv.anchor(left:view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,width: view.frame.width,height: 2)
        
        
        return view
        
    }
    func containerViewTextField2(textField : UITextField) -> UIView {
        let view = UIView()
        
        view.addSubview(textField)
        textField.anchor(top:view.topAnchor,left: view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,paddingBottom: 5)
        
        
        let sv = UIView()
        view.addSubview(sv)
        sv.backgroundColor = .gray300
        sv.anchor(left:view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,width: view.frame.width,height: 2)
        
        
        return view
        
    }
    
    func textField(text : String) -> UITextField {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray350,NSAttributedString.Key.font : UIFont.NotoRegular16!])
        
        
        return tf
    }
    
    
    func containerLabel(text : String) -> UILabel {
        let lb = UILabel()
        lb.text = text
        lb.font = UIFont.NotoBold16
        lb.textColor = .black900
 
        return lb
    }
    
    func buttonUI(setTitle title: String) -> UIButton {
        
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue500
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.anchor(height:56)
        button.titleLabel?.font = UIFont.NotoBold18
        
        return button
    }
    
    
    func PhoneAuthNumberinputContainerView(textField: UITextField,label : UILabel, sv : UIView) -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        view.addSubview(textField)
        textField.anchor(top:view.topAnchor,left: view.leftAnchor,right:view.rightAnchor,paddingLeft: 8,paddingBottom: 6)
        textField.setDimensions(width: 24, height: 30)
        textField.textColor = .black900
        textField.font = UIFont.NotoBold16
        
        
        
        view.addSubview(sv)
        
        
        
        sv.backgroundColor = .blue500
        sv.anchor(top:textField.bottomAnchor,left:view.leftAnchor,right:view.rightAnchor,paddingTop: 6,paddingLeft:8,height: 2)
        
        
        view.addSubview(label)
        label.anchor(top:view.topAnchor,bottom: sv.topAnchor,right: view.rightAnchor,paddingTop: 7,paddingBottom:7)
        
        return view
    }
    
    
    func Label() -> UILabel {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 10)
        return lb
    }
    
    
    

    
    
    
}
