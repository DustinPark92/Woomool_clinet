//
//  UserGradeCollectionViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/09/19.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class UserGradeCollectionViewCell: UICollectionViewCell {
    
    var option: UsergradeOptions! {
        didSet {
            levelNameLabel.text = option.levelName
            benefitLabel.text = option.benefit
            conditionLabel.text = option.condition
            userGradeimg.image = option.gradeImage
            
        }
    }

    
    let userGradeimg : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "이슬")
        iv.setDimensions(width: 140, height: 140)
        iv.makeAcircle(dimension: 140)
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .userGradeBasic
        return iv
    }()
    
    let userLockImg : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "lock")
        iv.setDimensions(width: 70, height: 70)
        iv.contentMode = .scaleAspectFit
       return iv
    }()
    
    let userNowImg : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "now")
        iv.setDimensions(width: 57, height: 26)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let mainView : UIView = {
        let uv = UIView()
        return uv
    }()
    
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    
    let levelNameLabel : UILabel = {
        let lb = UILabel()
        lb.font = UIFont.NotoLight30
        lb.textColor = .black900
        lb.text = "lv.1 이슬"
        return lb
    }()
    
    let conditionLabel : UILabel = {
        let lb = UILabel()
        lb.font = UIFont.NotoMedium12
        lb.textColor = .black400
        return lb
    }()
    
    let benefitLabel : UILabel = {
        let lb = UILabel()
        lb.font = UIFont.NotoMedium12
        lb.textColor = .black900
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        

      
        addSubview(mainView)
   
        userGradeimg.addSubview(userLockImg)
        
        userLockImg.center(inView: userGradeimg)

        
        addSubview(levelNameLabel)
        addSubview(conditionLabel)
        addSubview(benefitLabel)

        
        levelNameLabel.center(inView: self)
        mainView.centerX(inView: self, bottomAnchor: levelNameLabel.topAnchor, paddingBottm: 20)
        mainView.addSubview(userGradeimg)
        userGradeimg.addConstraintsToFillView(mainView)
        conditionLabel.centerX(inView: self, topAnchor: levelNameLabel.bottomAnchor, paddingTop: 7.16)
        benefitLabel.centerX(inView: self, topAnchor: conditionLabel.bottomAnchor, paddingTop: 0)

        
        
        
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: 70, y: 70), radius: 82, startAngle: -CGFloat.pi / 2 , endAngle: 2 * CGFloat.pi, clockwise: true)

        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        trackLayer.strokeColor = UIColor.gray300.cgColor
        trackLayer.lineWidth = 5
        mainView.layer.addSublayer(trackLayer)
        
        let circularPathMain = UIBezierPath(arcCenter: CGPoint(x: 70, y: 70), radius: 82, startAngle: CGFloat.pi / 2 , endAngle: -CGFloat.pi / 2, clockwise: true)

        shapeLayer.backgroundColor = UIColor.white.cgColor
        shapeLayer.strokeEnd = 0
        shapeLayer.path = circularPathMain.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeColor = UIColor.blue500.cgColor
        shapeLayer.lineWidth = 5
        mainView.layer.addSublayer(shapeLayer)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        mainView.addSubview(userNowImg)
        userNowImg.centerX(inView: mainView, topAnchor: mainView.bottomAnchor, paddingTop: 0)
        userNowImg.bringSubviewToFront(mainView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleTap() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
        
    }
    
    
    
    
    
}
