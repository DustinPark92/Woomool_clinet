//
//  OnBoardingModel.swift
//  Woomool
//
//  Created by Dustin on 2020/08/29.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class OnBoardingModel {
    
    
    let onBoardingTitle = ["잠들어있는 텀블러와 \n함께 우물을 찾아 떠나요.","우물 이용권으로\n 음료 할인 받고, 환경을 지켜요.","나의 일상이 모여\n 깨끗한 지구를 만들어요."]
    
    
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
    func attributedButton(_ firstPart: String) -> UIButton {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: firstPart, attributes: [NSAttributedString.Key.font :UIFont.systemFont(ofSize: 16),NSAttributedString.Key.foregroundColor: UIColor.black900])
        attributedTitle.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, firstPart.count))
               
     
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        
        return button
    }
    
    
    
    
}
