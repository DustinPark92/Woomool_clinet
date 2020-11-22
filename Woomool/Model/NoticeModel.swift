//
//  NoticeModel.swift
//  Woomool
//
//  Created by Dustin on 2020/10/11.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

struct NoticeModel {
    
    /*
     {
       "serialNo": 2,
       "category": "가입축하",
       "title": "우물 회원이 되신걸 축하드립니다.",
       "contents": "추카추카",
       "status"
     */
    var open = false
    var serialNo : Int
    var category : String
    var title : String
    var contents : String
    var status : String
    
    
    
}

struct NoticeListModel {
    /*
     "noticeId": "N1",
     "title": "공지사항1",
     "displayDate": "2020-11-02"
     */
    
    let noticeId : String
    let title : String
    let displayDate : String
    
    

}
