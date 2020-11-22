//
//  BestAskViewModel.swift
//  Woomool
//
//  Created by Dustin on 2020/09/06.
//  Copyright © 2020 Woomool. All rights reserved.
//

import Foundation

enum BestAskOption : Int, CaseIterable {
    case forUsing
    case forPartner
    case pay
    case refund
    case product
    case coupon

    
    var description: String{
        switch self {
        case .forUsing:
            return "이용 관련"
        case .forPartner:
            return "가맹점"
        case .pay:
            return "결제"
        case .refund:
            return "환불"
        case .product:
            return "상품"
        case .coupon:
            return "쿠폰"
        }
    }
}

 
