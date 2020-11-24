//
//  HistoryModel.swift
//  Woomool
//
//  Created by Dustin on 2020/11/23.
//  Copyright © 2020 Woomool. All rights reserved.
//

import Foundation



struct HistoryAllModel {
    /*
     {
       "name" : "15회 이용권",
       "countPrice" : 9900,
       "date" : "2020-11-23",
       "serialNo" : 16,
       "types" : "G"
     },

     
     */
    
    let name : String
    let countPrice : Int
    let date : String
    let serialNo : Int
    let types : String
    
    
    
}


struct HistoryGoodsModel {
    let serialNo : Int
    let buyDate : String
    let goodsId : Int
    let name : String
    let buyPrice : Int
    /*
     {
       "serialNo" : 10,
       "buyDate" : "2020-11-23",
       "goods" : {
         "goodsId" : "GD20201111143844998",
         "name" : "31회 이용권"
       },
       "buyPrice" : 18000
     },
     */
}


struct HistoryStoreModel {
    /*
     {
       "serialNo" : 13,
       "useCount" : 1,
       "store" : {
         "storeId" : "V7T1P08C895SPDJ78IZ8",
         "name" : "앤트러사이트 강남점"
       },
       "useDate" : "2020-11-24"
     }
     */
    let serialNo : Int
    let useCount : Int
    let storeId : String
    let name : String
    let useDate : String


}
