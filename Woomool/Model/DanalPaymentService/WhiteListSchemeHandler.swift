//
//  WhiteListSchemeHandler.swift
//  Woomool
//
//  Created by Dustin on 2020/12/06.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class WhiteListSchemeHandler: SchemeHandler {

    override func openScheme(requestedURL: NSURL) -> Bool {
        var isEnable = false;
        
        if( UIApplication.shared.canOpenURL(requestedURL as URL) )
        {
            // APP Sceheme 값이 info.plist 를 통해 White List 처리 되어 있으며, 앱이 설치 되어 있어서 호출 가능 할 경우
            isEnable = true;
        }
        else
        {
            isEnable = false;
            /*
             URL Scheme 값이 White List 에 등록 안되어 있을 경우
             == -canOpenURL: failed for URL: "xxx://?xxx=xxx" - error: "This app is not allowed to query for scheme ispmobile"
             
             
             URL Scheme 값이 White List 에 등록 되어 있으나, URL Scheme Open을 할 수 없을 경우
             == -canOpenURL: failed for URL: "xxx://?xxx=xxx" - error: "The operation couldn’t be completed. (OSStatus error -10814.)"
             */
        }
        
        return isEnable;
    }
    
}
