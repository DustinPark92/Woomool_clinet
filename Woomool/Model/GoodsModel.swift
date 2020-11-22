//
//  GoodsModel.swift
//  Woomool
//
//  Created by Dustin on 2020/11/02.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit




struct GoodsModel {
    /*
     {
       "goodsId": "G2",
       "name": "30회 이용권",
       "description": "상품 설명입니다.",
       "image": "http://",
       "goodsType": "C",
       "ableCount": 30,
       "originPrice": 20000,
       "salePrice": 18000,
       "discountRate": 10
     }
     */
    
    let goodsId : String
    let name : String
    let description : String
    let image : String
    let goodsType : String
    let ableCount : Int
    let originPrice : Int
    let salePrice : Int
    let discountRate : Int
    
}
