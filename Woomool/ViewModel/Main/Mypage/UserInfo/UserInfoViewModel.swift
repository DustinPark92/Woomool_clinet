//
//  UserInfoViewModel.swift
//  Woomool
//
//  Created by Dustin on 2020/09/03.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

enum userInfoType: Int,CaseIterable {
    case name
    case birth
    case sex
    case email
    case nickname
    case phoneNumber
    case password
    
    var description: String{
        switch self {
        case .name:
            return "이름"
        case .birth:
            return "생년월일"
        case .sex:
            return "성별"
        case .email:
            return "이메일"
        case .nickname:
            return "닉네임"
        case .phoneNumber:
            return "휴대폰 번호"
        case .password:
            return "비밀번호"
        }
    }
    
//    var placeHolder : String {
//        switch self {
//     
//        case .name:
//            
//        case .birth:
//            <#code#>
//        case .sex:
//            <#code#>
//        case .email:
//            <#code#>
//        case .nickname:
//            <#code#>
//        case .pho neNumber:
//            <#code#>
//        case .password:
//            <#code#>
//        }
    
    
    
}

class UserInfoViewModel {
    
    func textField(withPlaceholder placeholder : String) -> UITextField {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.black400])
        return tf
    }
    
    
    
}
