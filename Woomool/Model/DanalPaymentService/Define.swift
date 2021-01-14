//
//  Define.swift
//  Woomool
//
//  Created by Dustin on 2020/12/06.
//  Copyright © 2020 Woomool. All rights reserved.
//

import Foundation


class Define
{
    
    //WARNING PAY_SERVER_URL 정보는 가맹점앱과 연동되는 웹서버 주소를 입력하셔야 샘플애서 확인 가능 합니다.
    static let PAY_SERVER_URL = "https://www.woomool.kr";
    /// 샘플 앱의 CUSTOM URL SCHEME 값
    static let SAMPLE_APP_SCHEME = "okaydanalpay";
    
    static let DEF_DEFAULT_PLIST = "pay_app_urls.plist";
};


struct Global {
    
    struct DEF {
        // 결제 시작 페이지 URL
        static let ORDER_URL : String = "가맹점 결제 처리 웹 또는 결제 처리 규격 URL";
        // 결제 처리 완료 후 앱이 재 호출 되었을때 결제 완료 처리 URL
        static let BILL_URL : String = "결제 리턴값 처리가 필요할 경우( 결과 리턴 값 파라매터가 RETURNPARAMS 있을 경우)";
        static let SAMPLE_APP_SCHEME : String = "banksample-swift";
        static let IS_ENABLE_APPSCHEME_WHITE_LIST : Int = 1;
    }
    
}
