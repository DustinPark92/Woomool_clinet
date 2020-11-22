//
//  HowtoUseViewModel.swift
//  Woomool
//
//  Created by Dustin on 2020/09/19.
//  Copyright © 2020 Woomool. All rights reserved.
//


import UIKit

enum HowToUseOption : Int, CaseIterable {
    case one
    case two
    case three
    case four
    case five
    
    var description: String{
        switch self {
        case .one:
            return "일리님, \n우물 이용방법을 \n알려드릴게요!"
        case .two:
            return "먼저, \n우물 이용권을 \n구매해주세요"
        case .three:
            return "내 근처 우물을 \n찾아보세요"
        case .four:
            return "우물 매장의 \nQR코드를 찍고,\n이용권을 사용해요"
        case .five:
            return "텀블러를 사용한만큼 \n깨끗해진 지구를 \n확인해요."
        }
    }
    
    var remark: String{
        switch self {
        case .one:
            return ""
        case .two:
            return "나의 우물 > 이용권 구매"
        case .three:
            return "내 근처 우물 > 가맹점 발견"
        case .four:
            return "홈 > 사용하기"
        case .five:
            return "나의우물 > 나의 환경보호"
        }
    }
    
    
    var image : UIImage {
        switch self {
        case .one:
            return UIImage(named: "howtouse_1")!
        case .two:
            return UIImage(named: "howtouse_2")!
        case .three:
            return UIImage(named: "howtouse_3")!
        case .four:
            return UIImage(named: "howtouse_4")!
        case .five:
            return UIImage(named: "howtouse_1")!
            
        }
    }
}


    
    


class HowtoUseViewModel {
    
    


}
