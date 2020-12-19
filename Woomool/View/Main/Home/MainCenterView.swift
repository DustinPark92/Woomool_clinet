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
        iv.image = UIImage(named: "qrMain")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    

    
    let qrButton : UIButton = {
        let bt = UIButton()
        //bt.setImage(UIImage(named: "Rectangle"), for: .normal)
        bt.addTarget(self, action: #selector(handleQrButton), for: .touchUpInside)
        return bt
    }()


    
    var delegate : MainCenterViewDelegate?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mainImg)

        addSubview(qrButton)
        
        mainImg.addConstraintsToFillView(self)
    
        qrButton.addConstraintsToFillView(mainImg)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleQrButton() {
        delegate?.goToScannerView()
        print(123)
    }
    
    
    
    
    
}
