//
//  CustomAlertViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/12/05.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class CustomAlertViewController: UIViewController {
    
    
    lazy var mainView = Utilites().customOKAlert(text: singleAlertContent.init(rawValue: beforeType)!.contentTitle, button: confirmButton)
    
    let confirmButton = UIButton()
    
    let beforeType : Int
    
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
        confirmButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
    }
    

    @objc func handleDismiss() {
        dismiss(animated: true) {
            switch self.beforeType {
            case singleAlertContent.woomoolService.rawValue:
                NotificationCenter.default.post(name: NSNotification.Name("popWoomoolService"), object: nil)
                
            case singleAlertContent.woomoolManagement.rawValue :
                NotificationCenter.default.post(name: NSNotification.Name("popWoomoolManagement"), object: nil)
                
            default : break
            
            }

        }
    }

}
