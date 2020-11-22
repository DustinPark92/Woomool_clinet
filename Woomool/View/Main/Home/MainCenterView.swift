//
//  MainCenterView.swift
//  Woomool
//
//  Created by Dustin on 2020/08/31.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

protocol MainCenterViewDelegate {
    func goToScannerView()
}


class MainCenterView: UIView {
    
    let mainImg : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "qrMain1")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let couponCountLabel : UILabel = {
        let lb = UILabel()
        lb.text = "15개"
        lb.textColor = .white
        lb.font = UIFont.NanumExtraBold34
        lb.textAlignment = .center
        
        return lb
    }()
    
    
    let couponLabel : UILabel = {
            let lb = UILabel()
            lb.text = "우물 이용권"
            lb.font = UIFont.NanumExtraBold16
            lb.textColor = .white
            return lb
        }()

    
    let qrButton : UIButton = {
        let bt = UIButton()
        //bt.setImage(UIImage(named: "Rectangle"), for: .normal)
        bt.addTarget(self, action: #selector(handleQrButton), for: .touchUpInside)
        return bt
    }()
    
    let qrLabel : UILabel = {
        let lb = UILabel()
        lb.text = "사용 하기"
        lb.font = UIFont.NanumExtraBold20
        lb.textColor = .blue500
        return lb
    }()
    

    
    var delegate : MainCenterViewDelegate?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mainImg)

        addSubview(qrButton)
        
        mainImg.center(inView: self)
        
        qrButton.addConstraintsToFillView(mainImg)
        
        addSubview(couponCountLabel)

//
        couponCountLabel.anchor(bottom:mainImg.bottomAnchor,right: mainImg.rightAnchor,paddingBottom: 21.84,paddingRight: 19.21)
//
//        couponLabel.anchor(bottom:couponLabel.topAnchor,right: rightAnchor,paddingTop: 220,paddingRight: 44)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleQrButton() {
        delegate?.goToScannerView()
        print(123)
    }
    
    
    
    
    
}
