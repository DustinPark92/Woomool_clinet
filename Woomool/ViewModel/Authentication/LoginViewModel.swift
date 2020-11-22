//
//  LoginViewModel.swift
//  Woomool
//
//  Created by Dustin on 2020/08/26.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit


class LoginViewModel {
    
    func inputContainerView(textField: UITextField) -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        

        view.addSubview(textField)
        textField.anchor(left: view.leftAnchor,bottom: view.bottomAnchor,right:view.rightAnchor,paddingLeft: 8,paddingBottom: 8)
        textField.setDimensions(width: 24, height: 24)
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.textColor = .white

        
        let sv = UIView()
        view.addSubview(sv)
        sv.backgroundColor = .white
        sv.anchor(left:view.leftAnchor, bottom:view.bottomAnchor,right:view.rightAnchor,paddingLeft:8,height: 2)
        
       
        
        
        return view
    }
    
    func textField(withPlaceholder placeholder : String) -> UITextField {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray350])
            return tf
    }
    
    func attributedButton(_ firstPart: String) -> UIButton {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: firstPart, attributes: [NSAttributedString.Key.font :UIFont.systemFont(ofSize: 16),NSAttributedString.Key.foregroundColor: UIColor.white])
     
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        
        return button
    }
    
    func buttonUI(setTitle title: String) -> UIButton {
        
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.init(white: 1, alpha: 0.4), for: .normal)
        button.backgroundColor = .init(white: 1, alpha: 0.2)
        button.layer.cornerRadius = 28
        button.clipsToBounds = true
        button.anchor(height:56)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)

        return button
    }
    
}
