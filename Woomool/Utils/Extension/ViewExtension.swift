//
//  ViewExtension.swift
//  Woomool
//
//  Created by Dustin on 2020/08/26.
//  Copyright © 2020 Woomool. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        left: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        right: NSLayoutXAxisAnchor? = nil,
        paddingTop : CGFloat = 0,
        paddingLeft : CGFloat = 0,
        paddingBottom : CGFloat = 0,
        paddingRight : CGFloat = 0,
        width: CGFloat? = nil,
        height: CGFloat? = nil) {
        
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    
    
    func center(inView view: UIView, yConstant: CGFloat? = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo:view.centerYAnchor , constant: yConstant!).isActive = true
        
    }
    
    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil,bottomAnchor:NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = 0,paddingBottm: CGFloat? = 0 ) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop!).isActive = true
        }
        
        if let bottomAnchor = bottomAnchor{
            self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -paddingBottm!).isActive = true
        }
    }
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat? = nil,
                 constant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant!).isActive = true
        
        if let leftAnchor = leftAnchor, let padding = paddingLeft {
            
            self.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
        }
        
        
        
    }
    
    
    func setDimensions(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func addConstraintsToFillView(_ view: UIView) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
    func makeAborderWidth(border: CGFloat, color: CGColor) {
        
        self.layer.borderColor = color
        self.layer.borderWidth = border
        
    }
    
    func makeAcircle( dimension : Int) {
        
        self.layer.cornerRadius = CGFloat(dimension / 2)
        self.clipsToBounds = true
        self.setDimensions(width: CGFloat(dimension), height: CGFloat(dimension))
        
        
    }
    
    func makeAborder(radius: Int) {
        self.layer.cornerRadius = CGFloat(radius)
        self.clipsToBounds = true
    }
    
    
    func drawDottedLine(start p0: CGPoint, end p1: CGPoint, view: UIView) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [7, 3] // 7 is the length of dash, 3 is length of the gap.

        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
    }
    
    func createDashedLine(from point1: CGPoint, to point2: CGPoint, color: UIColor, strokeLength: NSNumber, gapLength: NSNumber, width: CGFloat) {
        let shapeLayer = CAShapeLayer()

        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineDashPattern = [strokeLength, gapLength]

        let path = CGMutablePath()
        path.addLines(between: [point1, point2])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
    private static let lineDashPattern: [NSNumber] = [2, 2]
    private static let lineDashWidth: CGFloat = 1.0

    func makeDashedBorderLine() {
        let path = CGMutablePath()
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = UIView.lineDashWidth
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineDashPattern = UIView.lineDashPattern
        path.addLines(between: [CGPoint(x: bounds.minX, y: bounds.height/2),
                                CGPoint(x: bounds.maxX, y: bounds.height/2)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
}
