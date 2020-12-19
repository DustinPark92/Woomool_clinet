//
//  CouponViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/11/13.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit
private let reuseIdentifier = "CouponCell"
private let headerIdentifier = "CouponHeader"


protocol CouponViewControllerDelegate : class {
    func couponSelected(couponModel : CouponModel)
}

class CouponViewController: UIViewController {
    
    weak var delegate : CouponViewControllerDelegate?
    
    let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        return cv
    }()
    
    var couponModol = [CouponModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        callRequest()
        configureCollectionView()
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    func callRequest() {
        
        APIRequest.shared.getUserCoupon { json in
            for item in json.arrayValue {
                let couponItem = CouponModel(expiryDate: item["expiryDate"].stringValue, name: item["coupon"]["name"].stringValue, description: item["coupon"]["description"].stringValue, minusPrice: item["coupon"]["minusPrice"].intValue, types: item["coupon"]["types"].stringValue, plusCount: item["coupon"]["plusCount"].intValue, expiryDays: item["coupon"]["expiryDays"].intValue, couponId: item["coupon"]["couponId"].stringValue, imgae: item["coupon"]["imgae"].stringValue, couponNo: item["couponNo"].intValue)
                
                self.couponModol.append(couponItem)
            }
            
            self.collectionView.reloadData()
        } refreshSuccess: {
            APIRequest.shared.getUserCoupon { json in
                for item in json.arrayValue {
                    let couponItem = CouponModel(expiryDate: item["expiryDate"].stringValue, name: item["coupon"]["name"].stringValue, description: item["coupon"]["description"].stringValue, minusPrice: item["coupon"]["minusPrice"].intValue, types: item["coupon"]["types"].stringValue, plusCount: item["coupon"]["plusCount"].intValue, expiryDays: item["coupon"]["expiryDays"].intValue, couponId: item["coupon"]["couponId"].stringValue, imgae: item["coupon"]["imgae"].stringValue, couponNo: item["couponNo"].intValue)
                    
                    self.couponModol.append(couponItem)
                }
                
                self.collectionView.reloadData()
            } refreshSuccess: {
                print("nil")
            }
        }

    }
    
    
    func configureUI() {
        title = "쿠폰"
        view.backgroundColor = .white
        addNavbackButton(selector: #selector(handleDismiss))
        view.addSubview(collectionView)
        collectionView.anchor(top:view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor)
        collectionView.backgroundColor = .white
    }

    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CouponCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(CouponHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        
    }
    
    @objc func handleDismiss() {
        
        navigationController?.popViewController(animated: true)
    }
    

    

}


extension CouponViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 32, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 126)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.couponSelected(couponModel: couponModol[indexPath.item])
        navigationController?.popViewController(animated: true)
    }
    
}

extension CouponViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return couponModol.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CouponCell
        let item = couponModol[indexPath.item]
        cell.backgroundColor = .white
        cell.mainLabel.text = item.description
        cell.subLabel.text = item.name
        cell.dateLabel.text = "~ \(item.expiryDate) 까지 이용가능"
        
        
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath)
             as! CouponHeader
      
            return header
            
    }
    
    
}
