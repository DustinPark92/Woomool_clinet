//
//  LoadingHUD.swift
//  Woomool
//
//  Created by Dustin on 2021/01/02.
//  Copyright © 2021 Woomool. All rights reserved.
//


import Foundation
import UIKit
import SwiftGifOrigin

class LoadingHUD {
    private static let sharedInstance = LoadingHUD()
    
    private var backgroundView: UIView?
    private var popupView: UIImageView?
    private var loadingLabel: UILabel?
    
    class func show() {
        let backgroundView = UIView(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        
        let popupView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        popupView.loadGif(name: "loader")
        popupView.animationDuration = 0.8
        popupView.animationRepeatCount = 0
        
        let loadingLabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        loadingLabel.font = UIFont.boldSystemFont(ofSize: 20)
        loadingLabel.textColor = .black
        
        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
            window.addSubview(backgroundView)
            window.addSubview(popupView)
            window.addSubview(loadingLabel)
            
            backgroundView.frame = CGRect(x: 0, y: 0, width: window.frame.maxX, height: window.frame.maxY)
            backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
            
            popupView.center = window.center
            popupView.startAnimating()
            
            loadingLabel.layer.position = CGPoint(x: window.frame.midX, y: popupView.frame.maxY + 10)
            
            sharedInstance.backgroundView?.removeFromSuperview()
            sharedInstance.popupView?.removeFromSuperview()
            sharedInstance.loadingLabel?.removeFromSuperview()
            sharedInstance.backgroundView = backgroundView
            sharedInstance.popupView = popupView
            sharedInstance.loadingLabel = loadingLabel
        }
    }
    
    class func hide() {
        if let popupView = sharedInstance.popupView,
            let loadingLabel = sharedInstance.loadingLabel,
        let backgroundView = sharedInstance.backgroundView {
            popupView.stopAnimating()
            backgroundView.removeFromSuperview()
            popupView.removeFromSuperview()
            loadingLabel.removeFromSuperview()
        }
    }

    private class func getAnimationImageArray() -> UIImage {
        return UIImage(named: "coupon_Img")!
    }
}



