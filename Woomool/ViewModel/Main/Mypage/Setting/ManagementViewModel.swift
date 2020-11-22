//
//  ManagementViewModel.swift
//  Woomool
//
//  Created by Dustin on 2020/09/12.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class ManagementViewModel {
    
    func inputContainerView(textField : UITextField) -> UIView  {
        let view = UIView()
        view.anchor(height: 46)
        view.backgroundColor = .gray100
        view.makeAborder(radius: 14)
        view.makeAborderWidth(border: 1, color: UIColor.gray300
            .cgColor)
        
        
       let searchImg = UIImageView()
        searchImg.setDimensions(width: 30, height: 30)
        searchImg.image = UIImage(named: "setting_search")

        
        view.addSubview(searchImg)
        view.addSubview(textField)
        
        
        searchImg.anchor(top:view.topAnchor,left: view.leftAnchor,paddingTop: 8,paddingLeft: 8)
        textField.anchor(top:view.topAnchor,left: searchImg.rightAnchor,paddingTop:12,paddingRight:8)
 
       
        return view
    }
    
    func textField(placeholder : String) -> UITextField {
        let tf = UITextField()
        tf.backgroundColor = .clear
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray350,NSAttributedString.Key.font : UIFont.NotoMedium14!])
        
        
        return tf
    }
    
    func submitButtonUI(setTitle title: String) -> UIButton {
        
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue500
        button.anchor(height:56)
        button.titleLabel?.font = UIFont.NotoBold18

        return button
    }
}


