//
//  CustomAlertViewController2.swift
//  Woomool
//
//  Created by Dustin on 2020/12/05.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class CustomAlertViewController2: UIViewController {

    lazy var mainView = Utilites().customTwoButtonAlert(text: twoAlertContent.init(rawValue: beforeType)!.contentTitle, confirmButton: confirmButton, cancelButton: cancelButton)
    
    let confirmButton = UIButton()
    let cancelButton = UIButton()
    
    let beforeType : Int
    var deleteUserReason = ""
    
    init(beforeType : Int) {
        self.beforeType = beforeType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.addSubview(mainView)
        mainView.center(inView: view)
        mainView.setDimensions(width: view.frame.width - 32, height: 300)
        confirmButton.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    

    @objc func handleConfirm() {
        dismiss(animated: true) {
            switch self.beforeType {
            case twoAlertContent.userLogOut.rawValue:
                self.delUserInfo()
                
            case twoAlertContent.userDelete.rawValue :
                APIRequest.shared.delUser(reason: self.deleteUserReason) { json in
                    self.delUserInfo()
                } fail: { error in
                    
                    print("[\(error.status)] \(error.code)=\(error.message)")
                    self.showOkAlert(title:  "[\(error.status)] \(error.code)=\(error.message)", message: "") {
                        
                    }
                }

                
                
            default : break
            
            }

        }
    }
    
    func delUserInfo() {
        

        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "")
        
        let controller = OnBoardingViewController()
        let nav = UINavigationController(rootViewController: controller)
        UIApplication.shared.windows.first?.rootViewController = nav
        UIApplication.shared.windows.first?.makeKeyAndVisible()


    }

}
