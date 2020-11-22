//
//  ColorExtension.swift
//  Woomool
//
//  Created by Dustin on 2020/08/26.
//  Copyright © 2020 Woomool. All rights reserved.
//

import Foundation
import UIKit
import Hex


extension UIColor {
    
    var bg : UIColor {
        return UIColor(named: "bg")!
    }
    
    var forgetPassPlaceHolder : UIColor {
        return UIColor(named: "forgetPassPlaceHolder")!
        
    }
    
    var invalidInfo : UIColor {
        return UIColor(named: "invalidInfo")!
        
    }
    
    var mainWhite : UIColor {
        return UIColor(named: "mainWhite")!
    }
    
    
    static var blue500 : UIColor {
        return UIColor.init(hex: "3BCCFF")
    }
    static var blue300 : UIColor {
        return UIColor.init(hex: "89DDFF")
    }
    static var blue700 : UIColor {
        return UIColor.init(hex: "044FA9")
    }
    
    static var gray500 : UIColor {
        return UIColor.init(hex: "2E3A59")
    }
    static var gray400 : UIColor {
        return UIColor.init(hex: "8F9BB3")
    }
    static var gray350 : UIColor {
        return UIColor.init(hex: "C2C9D6")
    }
    static var gray300 : UIColor {
        return UIColor.init(hex: "E4E9F2")
    }
    static var gray200 : UIColor {
        return UIColor.init(hex: "EDF1F7")
    }
    static var gray100 : UIColor {
        return UIColor.init(hex: "F7F9FC")
    }
    static var black900 : UIColor {
        return UIColor.init(hex: "2B292D")
    }
    static var black400 : UIColor {
        return UIColor.init(hex: "ADB5BD")
    }
    static var bestAsk : UIColor {
        return UIColor.init(hex: "#F5F5F5")
    }

    static var cancelGray : UIColor {
        return UIColor.init(hex: "##8F9BB3")
    }

    static var userGradeBasic : UIColor {
        return UIColor.init(hex: "#F7F9FC")
    }
    
    
    
    
//    var main : UIColor {
//        return UIColor(named: "main")!
//    }
//    var sub : UIColor {
//        return UIColor(named: "sub")!
//    }
//
//    var line : UIColor {
//        return UIColor(named: "sub")!.withAlphaComponent(0.5)
//    }
//    var textMain : UIColor {
//        return UIColor(named: "textMain")!
//    }
//
    
    
    
    
}
