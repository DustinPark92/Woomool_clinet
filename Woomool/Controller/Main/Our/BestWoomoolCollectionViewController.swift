//
//  BestWoomoolCollectionViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/09/12.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

private let reuseIdentifier = "BestWoomoolCollectionViewCell"

class BestWoomoolCollectionViewController: UICollectionViewController {
    
    let viewModel = OurwoomoolViewModel()
    var bestWoomoolModel = [BestStoreModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIRequest.shared.getBestStoreList { json in
            
            for item in json.array! {
                let bestWoomoolItem = BestStoreModel(orders: item["orders"].intValue, storeId: item["storeId"].stringValue, name: item["name"].stringValue, address: item["address"].stringValue, scope: item["scope"].doubleValue)
      
                    self.bestWoomoolModel.append(bestWoomoolItem)
                
                
            }
            
            self.collectionView.reloadData()
            
        } fail: { error in
            self.showOkAlert(title:  "[\(error.status)] \(error.code)=\(error.message)", message: "") {
                
            }
        }
        
        
        configureUI()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    func configureUI() {
        title = "베스트 우물"
        collectionView.backgroundColor = .white
        collectionView.register(BestWoomoolCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        addNavbackButton(selector: #selector(handleDismiss))
        
    }

    
    @objc func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: UICollectionViewDataSource



    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return bestWoomoolModel.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BestWoomoolCollectionViewCell
        
        let item = bestWoomoolModel[indexPath.row]
        cell.storeNameLabel.text = item.name
        cell.rankLabel.text = String(item.orders)
        cell.adressLabel.text = item.address
        cell.rateLabel.text = String(item.scope)
        
        
        cell.backgroundColor = .white
        cell.makeAborder(radius: 14)
        switch indexPath.row {
        case 0...2:
            cell.mainImageView.image = UIImage(named: viewModel.bestwoomoolImg[indexPath.row])
            cell.backgroundColor = .blue500
        case 2...bestWoomoolModel.count:
            cell.makeAborderWidth(border: 1, color: UIColor.gray300.cgColor)
            cell.rateLabel.textColor = .black400
            cell.rankLabel.textColor = .gray500
            cell.upDownLabel.textColor = .gray500
            cell.adressLabel.textColor = .gray500
            cell.storeNameLabel.textColor = .gray500
        default:
            break
        }
        
        return cell
    }



}


extension BestWoomoolCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 311, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 32, left: 32, bottom: 8, right: 32)
    }
    
    
}
