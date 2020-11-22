//
//  CouponPopUpViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/09/18.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit


protocol  CouponPopUpViewControllerDelegate{
    func popToMypage()
}

class CouponPopUpViewController: UIViewController {
    
    let viewModel = MypageViewModel()
    lazy var centerView = viewModel.couponPopUpView(collectionView: collectionView, usingRule: usingRuleLabel, usingRuleDeatil: usingRuleDetailLabel, confirmButton: confirmButton, cancelButton: cancelButton)
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    lazy var usingRuleLabel = UILabel()
    lazy var usingRuleDetailLabel = UILabel()
    
    lazy var confirmButton = UIButton()
    lazy var cancelButton = UIButton()
    
    var delegate : CouponPopUpViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
       
    }
    

    func configureUI() {
        view.isOpaque = false
        view.backgroundColor = .clear
        view.addSubview(centerView)
        centerView.center(inView: view)
        centerView.setDimensions(width: view.frame.width - 32, height: view.frame.height / 1.8)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CouponCollectionViewCell.self, forCellWithReuseIdentifier: "CouponCollectionViewCell")
        confirmButton.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
    }
    
    @objc func handleConfirm() {
        dismiss(animated: true) {
            self.delegate?.popToMypage()
        }
    }
    
    @objc func handleCancel() {
        NotificationCenter.default.post(name: NSNotification.Name("alpha1"), object: nil)
        dismiss(animated: true, completion: nil)
    }
}

extension CouponPopUpViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CouponCollectionViewCell", for: indexPath) as! CouponCollectionViewCell
        return cell
    }
    

    
    
    
}

extension CouponPopUpViewController
: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 32, height: 120)
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
        
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 0)
    }
    
}
