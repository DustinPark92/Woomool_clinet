//
//  SceneDelegate.swift
//  Woomool
//
//  Created by Dustin on 2020/08/23.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit
import NaverThirdPartyLogin
import KakaoSDKCommon
import KakaoSDKAuth
import GoogleSignIn


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let defaults = UserDefaults.standard
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        if defaults.object(forKey: "refreshToken") as? String != nil {

               let vc = MainTC()

               //let nav = UINavigationController(rootViewController: vc)
               window?.rootViewController = vc
               window?.makeKeyAndVisible()

           } else {
               let vc = OnBoardingViewController()
               let nav = UINavigationController(rootViewController: vc)


               window?.rootViewController = nav
               window?.makeKeyAndVisible()

           }
////       let tabBar = MainTC()
//
//
////        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
////        window?.windowScene = windowScene
//////
//        window?.rootViewController = UINavigationController(rootViewController: OnBoardingViewController())
////    window?.rootViewController = UINavigationController(rootViewController: tabBar)
////
////        tabBar.selectedIndex = 0
////        window?.rootViewController = tabBar
//

        window?.makeKeyAndVisible()
        
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        guard let url = URLContexts.first?.url else { return }
        
 
        
        NaverThirdPartyLoginConnection
                    .getSharedInstance()?
                    .receiveAccessToken(url)
        
        guard let scheme = URLContexts.first?.url.scheme else { return }
        if scheme.contains("com.googleusercontent.apps") {
            GIDSignIn.sharedInstance().handle(URLContexts.first?.url)
        }
        if let url = URLContexts.first?.url {
          if (AuthApi.isKakaoTalkLoginUrl(url)) {
            _ = AuthController.handleOpenUrl(url: url)
          }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
       
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

