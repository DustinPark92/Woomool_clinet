//
//  CouponSelectViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/09/18.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CouponCollectionViewCell"

class CouponSelectViewController: UIViewController {
    
    
    let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)

        return cv
    }()
    
    let noCouponLabel : UILabel = {
        let lb = UILabel()
        lb.text = "조회가능한 쿠폰이 없습니다."
        lb.font = UIFont.NotoBold16
        lb.textColor = .black400
        return lb
       }()
    
    let noCouponImage : UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 24, height: 24)
        iv.image = UIImage(named: "noCouponLogo")
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        NotificationCenter.default.addObserver(self, selector: #selector(alpha1(noti:)), name: NSNotification.Name("alpha1"), object: nil)
        
    }
    

    func configureUI() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = false
        addNavbackButton(selector: #selector(handleDismiss))
        title = "쿠폰 선택"
        view.backgroundColor = .white
        view.addSubview(noCouponLabel)
        view.addSubview(noCouponImage)
        view.addSubview(collectionView)
        noCouponLabel.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: 50)
        noCouponImage.anchor(top:view.topAnchor,left: view.leftAnchor,paddingTop: 53,paddingRight: 75)
        collectionView.anchor(top:view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor)
        collectionView.backgroundColor = .white
        collectionView.register(CouponCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .bestAsk
        
        noCouponLabel.isHidden = true
        noCouponImage.isHidden = true
        
        
    }
    
    @objc func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
    @objc func alpha1(noti : Notification) {
        view.alpha = 1.0
        navigationController?.navigationBar.alpha = 1.0
        
    }
}

extension CouponSelectViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CouponCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.alpha = 0.5
        navigationController?.navigationBar.alpha = 0.5
        let controller = CouponPopUpViewController()
        controller.modalPresentationStyle = .overCurrentContext
        controller.delegate = self
        present(controller, animated: true) {

        }
    }
    
    
    
}

extension CouponSelectViewController : UICollectionViewDelegateFlowLayout {
    
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

extension CouponSelectViewController : CouponPopUpViewControllerDelegate {
    func popToMypage() {
        navigationController?.popViewController(animated: false)
    }
    
    
}
