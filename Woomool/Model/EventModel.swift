//
//  EventModel.swift
//  Woomool
//
//  Created by Dustin on 2020/11/02.
//  Copyright © 2020 Woomool. All rights reserved.
//

import Foundation


struct EventListModel {
    /*
     {
     "eventId" : "ET20201111175648999",
     "contents" : "이벤트 합니다.",
     "title" : "오픈 이벤트",
     "postDate" : "2020-11-11",
     "endDate" : "2020-12-31",
     "startDate" : "2020-11-11",
     "image" : "http:\/\/",
     "eventStatus" : "Y"
     }
     */
    
    let eventId : String
    let contents : String
    let postDate : String
    let endDate : String
    let startDate : String
    let image : String
    let title : String
    let displayDate : String
    let eventStatus : String
    
    

}
