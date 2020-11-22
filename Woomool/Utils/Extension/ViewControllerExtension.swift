//
//  ViewControllerExtension.swift
//  Woomool
//
//  Created by Dustin on 2020/09/06.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit


extension UIViewController {
    
    func addNavbackButton(selector : Selector) {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "left_arrow"), style: .done, target: self, action: selector)
              
        navigationItem.leftBarButtonItem?.tintColor = .black900
    }
    
    @objc func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    
    func showActionSheet(title : String,message : String) {


    }
    
}
