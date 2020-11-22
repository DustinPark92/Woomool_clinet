//
//  IntExtension.swift
//  Woomool
//
//  Created by Dustin on 2020/11/22.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit


extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}
