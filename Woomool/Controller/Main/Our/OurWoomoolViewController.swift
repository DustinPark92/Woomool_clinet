//
//  OutWoomoolViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/08/31.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

private let notiReuseIdentifier = "MyWoomoolNotiCollectionViewCell"



class OurWoomoolViewController: UIViewController {
    lazy var mainImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.setDimensions(width: view.frame.width, height: view.frame.height / 3.7)
        iv.image = UIImage(named: "ourWoomoolMain")
        return iv
    }()
    
    let notiCV : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return cv
    }()
    
    lazy var notiCVwidth = view.frame.width  - 64
    
    let bestWoolTableView = UITableView()
    var bestWoomoolModel = [BestStoreModel]()
    
    
    
    let notiCVlayout = UICollectionViewFlowLayout()
    let bestShopView = OurWoomoolBestShopView()
    let viewModel = MyWoomoolViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Request.shared.getBestStoreList { json in
            
            for item in json.array! {
                let bestWoomoolItem = BestStoreModel(orders: item["orders"].intValue, storeId: item["storeId"].stringValue, name: item["name"].stringValue, address: item["address"].stringValue, scope: item["scope"].doubleValue)
                
                if self.bestWoomoolModel.count < 3 {
                    self.bestWoomoolModel.append(bestWoomoolItem)
                }
                
            }
            
            self.bestWoolTableView.reloadData()
            
        }
       
        configureUI()
        configureCV()
        configureTV()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    

    func configureUI() {
        title = "우리 우물"
        view.backgroundColor = .white
        view.addSubview(mainImageView)
        view.addSubview(notiCV)
        view.addSubview(bestShopView)
        view.addSubview(bestWoolTableView)
        

        mainImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0)
        
        notiCV.centerX(inView: view, topAnchor: mainImageView.bottomAnchor, paddingTop: 24)
        notiCV.setDimensions(width: notiCVwidth, height: 70)
        
        bestShopView.centerX(inView: view, topAnchor: notiCV.bottomAnchor, paddingTop: 22)
        bestShopView.setDimensions(width: view.frame.width - 64, height: 36)
        bestWoolTableView.centerX(inView: view, topAnchor: bestShopView.bottomAnchor, paddingTop: 20)
        bestWoolTableView.anchor(bottom:view.safeAreaLayoutGuide.bottomAnchor,paddingBottom: view.frame.height / 6)
        bestWoolTableView.setDimensions(width: view.frame.width - 64, height: 144)

        

    }
    
    func configureTV() {
        bestWoolTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: bestWoolTableView.frame.width, height: 10))
                bestWoolTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: bestWoolTableView.frame.width, height: 10))
        bestWoolTableView.register(BestWoomoolTableViewCell.self, forCellReuseIdentifier: "BestWoomoolTableViewCell")
        bestWoolTableView.isScrollEnabled = false
        bestWoolTableView.addCorner()
        bestWoolTableView.addShadow()
        
        bestWoolTableView.delegate = self
        bestWoolTableView.dataSource = self
        bestShopView.plusButton.addTarget(self, action: #selector(handlePlusBtn), for: .touchUpInside)
        
    }
    
    func configureCV() {
        
        notiCV.delegate = self
        notiCV.dataSource = self
        notiCV.register(MyWoomoolNotiCollectionViewCell.self, forCellWithReuseIdentifier: notiReuseIdentifier)
        notiCVlayout.itemSize = CGSize(width: notiCVwidth/4, height: 70)
        notiCVlayout.minimumInteritemSpacing = 0
        notiCVlayout.minimumLineSpacing = 0
        notiCV.collectionViewLayout = notiCVlayout
        
    }
    
    @objc func handlePlusBtn() {
        let layout = UICollectionViewFlowLayout()
        let controller = BestWoomoolCollectionViewController(collectionViewLayout: layout)
        navigationController?.pushViewController(controller, animated: true)
        
    }

}

extension OurWoomoolViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NotificationType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: notiReuseIdentifier, for: indexPath) as! MyWoomoolNotiCollectionViewCell
        cell.notiLabel.text = viewModel.notiTitle[indexPath.row]
        cell.notiImg.image = UIImage(named: viewModel.notiCVImage[indexPath.row])
        cell.backgroundColor = .white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let controller = NotificationViewController()
            navigationController?.pushViewController(controller, animated: true)
        case 1:
            let controller = EventViewController()
            controller.type = "이벤트"
            navigationController?.pushViewController(controller, animated: true)
        case 2:
            let controller = HowtoUseViewController()
            navigationController?.pushViewController(controller, animated: true)
        case 3:
            
            let controller = WoomoolStoryViewController()
            navigationController?.pushViewController(controller, animated: true)
        default:
            break
        }
    }
    
    
}


extension OurWoomoolViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bestWoomoolModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BestWoomoolTableViewCell", for: indexPath) as! BestWoomoolTableViewCell
        
        
        let item = bestWoomoolModel[indexPath.row]

        cell.bestWoomoolRating.text = String(item.scope)
        cell.storeNameLabel.text = item.name
        cell.rankLabel.text = OurwoomoolViewModel().bestWoomoolRank[indexPath.row]
        
        cell.backgroundColor = .white
        cell.makeAborder(radius: 15)
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }
    
    
    
    
}
