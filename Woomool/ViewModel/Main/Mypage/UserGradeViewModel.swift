//
//  UserGradeViewModel.swift
//  Woomool
//
//  Created by Dustin on 2020/09/19.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit
enum UsergradeOptions : Int, CaseIterable {
    case level1
    case level2
    case level3
    case level4
    case level5

    
    var levelName: String{
        switch self {
        
        case .level1:
           return "lv.1 이슬"
        case .level2:
           return "lv.2 방울"
        case .level3:
           return "lv.3 샘"
        case .level4:
           return "lv.4 호수"
        case .level5:
          return "lv.5 바다"
        }
    }
    
    var condition: String{
        switch self {
        
        case .level1:
           return "0~299회 이용회원"
        case .level2:
           return "300회 이용회원"
        case .level3:
           return "500회 이용회원"
        case .level4:
           return "1000회 이용회원"
        case .level5:
          return "2000회 이용회원"
        }
    }
    
    var benefit: String{
        switch self {
        
        case .level1:
           return "이용권 1회 사용시 1000원 할인 "
        case .level2:
           return "나만의 텀블러 이름표와 \n텀블러 청소키트 제공"
        case .level3:
           return "등급 달성시 10회 추가 이용권과 \n텀블러 이름표,\n텀블러 청소키트,\n텀블러 제공"
        case .level4:
           return "등급 달성시 15회 추가 이용권과\n텀블러 이름표,\n텀블러 청소키트,\n텀블러,\n텀블러 가방 제공"
        case .level5:
          return "등급 달성시 13회 추가 이용권과\n골든 텀블러 이름표,\n텀블러 청소키트,\n골든 텀블러,\n텀블러 가방 제공"
        }
    
    }
    
    var gradeImage : UIImage {
        switch self {
        
        case .level1:
            return UIImage(named: "이슬")!
        case .level2:
            return UIImage(named: "방울")!
        case .level3:
            return UIImage(named: "샘")!
        case .level4:
            return UIImage(named: "강")!
        case .level5:
            return UIImage(named: "바다")!
        }
    }


}


class UserGradeViewModel {
    
    var userRankModel = [UserRankModel]()
    var index = 0
    var firstPage = 0
    var percentage = 0

    
    func callRequest(success : @escaping() -> (), fail : @escaping(ErrorHandling) -> ()) {
        APIRequest.shared.getUserRank { [self] json in

            for item in json.array! {
                let userRankItem = UserRankModel(levelId: item["levelId"].stringValue, name: item["name"].stringValue, orders: item["orders"].intValue, benefits: item["benefits"].stringValue, userStatus: item["userStatus"].stringValue, userRate: item["userRate"].intValue, standard: item["standard"].stringValue)
                

                    
                
                self.userRankModel.append(userRankItem)
            }
            
            index = self.userRankModel.firstIndex {
                $0.userStatus == "NOW"
            }!
            
            
            
            DispatchQueue.main.async {
                self.percentage = userRankModel[index].userRate
                success()
            }

    } fail: { error in
        fail(error)
    }
        
    }
    





}
