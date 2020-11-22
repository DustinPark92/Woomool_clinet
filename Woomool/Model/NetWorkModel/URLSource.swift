//
//  URLSource.swift
//  Woomool
//
//  Created by Dustin on 2020/09/04.
//  Copyright © 2020 Woomool. All rights reserved.
//

import Foundation

struct URLSource {
    
    static let common = "http://211.250.213.5:21100/wsa/"
    //MARK: - TOKEN
    //0. Access Token 관련
    /*
     1. POST : /oauth/token
     
     */
    
    static let token = "http://211.250.213.5:21100/woa/oauth/token"
    //MARK: - 회원처리

    //1. 회원처리
    /*
     회원 처리
     1.등록  POST : /v1/user
     2.변경  PUT : /v1/user
     3.조회  GET : /v1/user/{userId}
     4.탈퇴  DELETE : /v1/user/{userId}
     5.로그인 POST : /v1/user/login
     6.비밀번호 찾기 : /v1/user/password/{email}
     */
    static let user = common + "v1/user"
    static let login = common + "v1/user/login"
    static let findPW = common + "v1/user/password/"
    
    
    
    //MARK: - 이벤트
    //2. 이벤트
    /*
     1.이벤트 목록 GET : /v1/event
     2.이벤트 조회 GET : /v1/event/{eventNo}
     */
    
    static let event = common + "v1/event"
    //MARK: - 약관
    
    //3. 약관
    /*
     1. 약관 목록 GET : /v1/terms
     */
    
    static let terms = common + "v1/terms"
    
    //MARK: - 수질 신고
    //4. 수질신고
    /*
     1. 수질신고 등록 POST : /v1/complaint
     */
    
    static let complaint = common + "v1/complaint"
    
    
    //MARK: - 문의사항
    //5.문의 사항
    
    /*
     1. 문의 사항 목록 GET : /v1/faq
     2. 문의 사항 조회 GET : /v1/faq/{faqId}
        
     */
    
    static let faq = common + "v1/faq"
    
    
    //MARK: - 매장
    //6.매장
    
    /*
     1. 근처 매장 목록 GET : /v1/store > TEST : lat : 37.4921514 , long : 127.0118619
     2. QR 매장 이용 POST : /v1/store
     3. QR 매장 별점 PUT : /v1/store
     4. QR 매장 조회 GET : /v1/store/{stroeId}
     5. 매장 신청 POST : /v1/store/apply
     6. 베스트 매장 목록 GET : /v1/store/best
     7. 매장 검색 목록 GET : /v1/store/find/{name}
     
     */
    
    static let store = common + "v1/store"
    static let storeApply = common + "v1/store/apply"
    static let storeBest = common + "v1/store/best"
    static let storeFind = common + "v1/store/find/"
    

    //MARK: - 공지사항
    //7.공지사항
    /*
     1. 공지사항 목록 GET : /v1/notice
     2. 공지사항 목록 조회 GET : /v1/notice/{noticeNo}
     */
    
    static let notice = common + "v1/notice"
    
    //MARK: - 상품 목록
    //8.상품목록
    /*
     1.상품 목록 GET : /v1/goods/{userId}
     2.상품 결제 내역 GET : /v1/goods/users/{userId}
     
     */
    
    static let goods = common + "v1/goods/user/"
    static let goodPurchase = common + "v1/goods/users/"
    
    
    //MARK: - 불만 사항
    //9.불만사항
    /*
     1. 서비스 불만 POST : v1/complaint
     2. 매장 불만 POT : v1/complaint/store
     */
    
    static let serviceComplaint = common + "v1/complaint"
    
    static let storeComplaint = common + "v1/complaint/store"
    
    //MARK: - 쿠폰
    //10. 쿠폰
    /*
     1. 쿠폰 GET : v1/coupon/{userId}
     */
    
    static let coupon = common + "v1/coupon"
    
    //MARK: - 회원 등록
    //11. 회원등급
    
    static let userRank = common + "v1/level/"
    
    //MARK: - 배너
    
    static let banner = common + "v1/banner/position/"
    
    //MARK: - 유저 알림
    
    static let userNoti = common + "v1/message/users/"
    
    //MARK: - 초대코드
    static let invite = common + "v1/invite/users/"
    
}
