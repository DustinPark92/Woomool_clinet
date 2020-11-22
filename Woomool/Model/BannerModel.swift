//
//  BannerModel.swift
//  Woomool
//
//  Created by Dustin on 2020/11/22.
//  Copyright © 2020 Woomool. All rights reserved.
//

import Foundation

/*
 {
   "orders": 1,
   "banner": {
     "bannerId": "BN20201111210321999",
     "image": "http://211.250.213.5/images/banner_ad_1.png",
     "link": "http://m.naver.com",
     "eventId": null
   }
 },
 */
struct BannerModelHome {
    let orders : Int
    let bannerId : String
    let image : String
    let link : String
    let eventId : String

}
