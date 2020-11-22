//
//  QrAuthViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/08/27.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit




private let reuseIdentifier = "StarCollectionViewCell"

class QrAuthViewController: UIViewController {
    

    private lazy var mainView : UIView = QrViewModel().popUpView(image:imageView , centerlabel: centerLabel, confirmButton: confirmButton, cancelButton: cancelButton, cafeNameLabel: cafeNameLabel)
    
    private let imageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    
    
    private let centerLabel = UILabel()
    private let countLabel = UILabel()
    private let confirmButton = UIButton()
    private let cancelButton = UIButton()
    private let expandButton = UIButton()
    private let completeButton = UIButton()
    private let starCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        layout.itemSize = CGSize(width: 30, height: 30)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        return cv
    }()
    private let cafeNameLabel = UILabel()
    private let starRateView = StarRateView(frame: CGRect(x: 0, y: 0, width: 220, height: 40),totalStarCount: 5, currentStarCount: 2.5, starSpace: 10)
    
    private let starView = UIView()
    var counter = 60
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        
    }
    
    
    func configureUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.addSubview(mainView)
        mainView.center(inView: view)
        mainView.setDimensions(width: view.frame.width - 32, height: 400)
        cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(handleComplete), for: .touchUpInside)
        
        expandButton.addTarget(self, action: #selector(handleExpand), for: .touchUpInside)
        expandButton.isSelected = false
    }
    
    //MARK : - Objc
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc func updateCounter() {
        if counter > 0 {
            counter -= 1
            countLabel.text = "남은 시간 00:\(counter)"
        } else if counter == 0 {
            countLabel.text = "시간 만료"
        }
    }
    
    @objc func reupdateCounter() {
        
        
        if counter > 0 {
            counter -= 1
            countLabel.text = "남은 시간 00:\(counter)"
        } else if counter == 0 {
            countLabel.text = "시간 만료"
        }
    }
    
    @objc func handleConfirm() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        mainView = QrViewModel().popUpViewConfirm(image: imageView, centerlabel: centerLabel, countLabel: countLabel, confirmButton: completeButton, cancelButton: expandButton, starRateView: starRateView, starView: starView)
        
        
        starRateView.show(type: .half, isPanEnable: true, leastStar: 0) { score in
            print(score)
        }
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        
        configureUI()
        // dismiss(animated: true, completion: nil)
        
        
    }
    
    @objc func handleComplete() {
        dismiss(animated: true) {
             NotificationCenter.default.post(name: NSNotification.Name("pop"), object: nil)
        }
       
        
    }
    
    @objc func handleExpand(sender : UIButton) {
        counter = 59
        
    }
    
    
}

