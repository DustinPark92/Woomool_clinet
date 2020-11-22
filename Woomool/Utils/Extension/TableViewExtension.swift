//
//  TableViewExtension.swift
//  Woomool
//
//  Created by Dustin on 2020/09/07.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

extension UITableView {
    func addCorner(){
        self.layer.cornerRadius = 14
        self.clipsToBounds = true
    }

    func addShadow(){
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowRadius = 14
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        self.layer.masksToBounds = false
    }
}
