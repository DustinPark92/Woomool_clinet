//
//  UserDelViewModel.swift
//  Woomool
//
//  Created by Dustin on 2020/12/06.
//  Copyright © 2020 Woomool. All rights reserved.
//

import Foundation


enum userDelReason : Int , CaseIterable{
    case first
    case second
    case third
    case firth
    
    var description : String {
        
        switch self {
        case .first:
            return "앱 사용이 불편하거나 어려움"
        case .second:
            return "사용시 인센티브(보상)이 별로 없음"
        case .third:
            return "이용 할 수 있는 매장이 부족"
        case .firth:
            return "기타(직접입력)"
        }
        
    }
    
    
}

class UserDelViewModel {
    
}
