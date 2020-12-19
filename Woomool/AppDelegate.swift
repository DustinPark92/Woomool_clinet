//
//  AppDelegate.swift
//  Woomool
//
//  Created by Dustin on 2020/08/23.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit
import NMapsMap
import NaverThirdPartyLogin
import KakaoSDKAuth
import KakaoSDKCommon
import GoogleSignIn

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
 

        
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        
        KakaoSDKCommon.initSDK(appKey: "c78838ca6c936a9fbd48a33c9e559f89")
        
        GIDSignIn.sharedInstance().clientID = "312835334837-i85na56d23ip1pk3i8gpmp8lmbvp27vt.apps.googleusercontent.com"

        
        // 네이버 앱으로 인증하는 방식을 활성화
        instance?.isNaverAppOauthEnable = true
        
        // SafariViewController에서 인증하는 방식을 활성화
        instance?.isInAppOauthEnable = true
        
        // 인증 화면을 iPhone의 세로 모드에서만 사용하기
        instance?.isOnlyPortraitSupportedInIphone()
        
        // 네이버 아이디로 로그인하기 설정
        // 애플리케이션을 등록할 때 입력한 URL Scheme
        instance?.serviceUrlScheme = kServiceAppUrlScheme
        // 애플리케이션 등록 후 발급받은 클라이언트 아이디
        instance?.consumerKey = kConsumerKey
        // 애플리케이션 등록 후 발급받은 클라이언트 시크릿
        instance?.consumerSecret = kConsumerSecret
        // 애플리케이션 이름
        instance?.appName = kServiceAppName
        
        NMFAuthManager.shared().clientId = "h1ck34g0c5"
        return true
    }

    // MARK: UISceneSession Lifecycle
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if( true == url.absoluteString.contains(Define.SAMPLE_APP_SCHEME) )
        {
        /*
            앱으로 복귀 하였을때 별도의 처리가 필요 할 경우
        수신된 url.absoluteString 값을 통하여 조치 하면 됩니다.
        */
        }
        return true;

        
        
        NaverThirdPartyLoginConnection.getSharedInstance()?.application(app, open: url, options: options)
        
        
        

        
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
          return AuthController.handleOpenUrl(url: url)
        }

        return false
      }

    

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func cookieSetting() -> Void
    {
        // 공용쿠키 설정
        let cookieStorage : HTTPCookieStorage = HTTPCookieStorage.shared;
        cookieStorage.cookieAcceptPolicy = HTTPCookie.AcceptPolicy.always;
        
        
        /// 기존에 쿠키를 저장한 내역이 있다면,,
        let cookiesData = UserDefaults.standard.data(forKey: "SavedCookies");
        
        if( false == cookiesData?.isEmpty )
        {
            let cookies = NSKeyedUnarchiver.unarchiveObject(with: cookiesData!) as? [HTTPCookie];
            
            for cookie in cookies!
            {
                HTTPCookieStorage.shared.setCookie(cookie);
            }
        }
        
        
        
    }
    
    /// @brief 쿠키 저장
    func saveCookie() -> Void
    {
        let cookies = HTTPCookieStorage.shared.cookies;
        let cookieData = NSKeyedArchiver.archivedData(withRootObject: cookies!);
        
        let userDefault : UserDefaults = UserDefaults.standard;
        userDefault.set(cookieData, forKey: "SavedCookies");
        userDefault.synchronize();
    }
    
    

}

