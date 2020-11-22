//
//  UserRequestViewModel.swift
//  Woomool
//
//  Created by Dustin on 2020/09/06.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

enum UserRequestOption : Int, CaseIterable {
    case request
    case question

    
    var description: String{
        switch self {
        case .request:
            return "수질관리 요청"
        case .question:
            return "자주 하는 질문"
        }
    }
}

 
class UserRequestViewModel {
    
    
    

func attributedButton(_ firstPart: String) -> UIButton {
    let button = UIButton(type: .system)
    let attributedTitle = NSMutableAttributedString(string: firstPart, attributes: [NSAttributedString.Key.font :UIFont.NotoMedium26!,NSAttributedString.Key.foregroundColor: UIColor.black900])
    attributedTitle.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, firstPart.count))
           
 
    
    button.setAttributedTitle(attributedTitle, for: .normal)
    
    
    return button
}

}
