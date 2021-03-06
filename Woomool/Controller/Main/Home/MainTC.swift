//
//  MainTC.swift
//  Woomool
//
//  Created by Dustin on 2020/08/26.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class MainTC: UITabBarController {
    

    
    //var userModel : UserModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .blue500
        tabBar.unselectedItemTintColor = .gray350
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureViewController()
    }
    
 
       
    

    

    func configureViewController() {
        
        //tab bar 박기

        let main = MainViewController()
        let recent = MyAreaViewController()
        let mypage = MypageViewController()
        let ourWoomool = OurWoomoolViewController()
  
        
        let nav1 = templateNavigationController(image: UIImage(named: "home"), rootViewController: main, title: "홈")
        let nav2 = templateNavigationController(image: UIImage(named: "map"), rootViewController: recent, title: "내 근처 우물")
        let nav3 = templateNavigationController(image: UIImage(named: "our"), rootViewController: ourWoomool, title: "우리 우물")
        let nav4 = templateNavigationController(image: UIImage(named: "my"), rootViewController: mypage, title: "나의 우물")
        

        viewControllers = [nav1,nav2,nav3,nav4]
        
        
    }
    
    func templateNavigationController(image: UIImage?, rootViewController: UIViewController, title: String) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.title = title
        nav.navigationBar.barTintColor = .white
        
        return nav
    }
    
    //MARK : - Selectors
    


}
