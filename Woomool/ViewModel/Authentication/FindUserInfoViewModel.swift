//
//  FindUserInfoViewModel.swift
//  Woomool
//
//  Created by Dustin on 2020/08/26.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit


class FindUserInfoViewModel {
    
    let color = UIColor()
    
    func inputContainerView(textField: UITextField) -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
//        let iv = UIImageView()
//        iv.image = image
//        view.addSubview(iv)
//        iv.anchor(left: view.leftAnchor , bottom: view.bottomAnchor , paddingLeft: 8 , paddingBottom: 8)
//        iv.setDimensions(width: 24, height: 24)
        
        

        view.addSubview(textField)
        textField.anchor(left: view.leftAnchor,bottom: view.bottomAnchor,right:view.rightAnchor,paddingLeft: 8,paddingBottom: 8)
        textField.setDimensions(width: 24, height: 24)
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.textColor = .black
        
        
        
        let sv = UIView()
        view.addSubview(sv)
        sv.backgroundColor = color.forgetPassPlaceHolder
        sv.anchor(left:view.leftAnchor, bottom:view.bottomAnchor,right:view.rightAnchor,paddingLeft:8,height: 2)
       
        
        
        return view
    }
    
    func textField(withPlaceholder placeholder : String) -> UITextField {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor :    color.forgetPassPlaceHolder.cgColor])

            return tf
    }
    
    func inValidEmailString(text : String) -> UILabel {
        let lb = UILabel()
        lb.text = text
        lb.textColor = color.invalidInfo
        lb.font = UIFont.systemFont(ofSize: 12)
        return lb
    }
    

    
    func buttonUI(setTitle title: String) -> UIButton {
        
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(color.forgetPassPlaceHolder, for: .normal)
        button.makeAborderWidth(border: 1, color: color.forgetPassPlaceHolder.cgColor)
        button.layer.cornerRadius = 28
        button.clipsToBounds = true
        button.anchor(height:48)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)

        return button
    }
    
}
