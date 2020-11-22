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
    
    
    func showOkAlert(title : String, message : String ,fail : @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let addAction = UIAlertAction(title: "확인", style: .cancel) { _ in
            fail()
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(addAction)
        present(alert, animated: true, completion: nil)
        
    }

}
