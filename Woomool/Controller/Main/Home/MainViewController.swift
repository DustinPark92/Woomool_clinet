//
//  MainViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/08/26.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MainCollectionViewCell"

class MainViewController: UIViewController {
    
    var userModel: UserModel? {
        didSet {
            mainLabel.text = "안녕하세요 \(userModel!.nickname)님"
//            mainCetnerView.couponCountLabel.text = "\(userModel!.ableCount)"
        }
    }
    

    private let mainLabel : UILabel = {
        let lb = UILabel()
        lb.text = "안녕하세요 일리님"
        lb.font = UIFont.NotoMedium20
        
        return lb
    }()
    
    private let subLabel : UILabel = {
        let lb = UILabel()
        lb.text = "우물을 찾아 떠나볼까요?"
        lb.font = UIFont.NotoMedium20
        return lb
    }()
    
    let mainCetnerView = MainCenterView()
    

    

    

    
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.width - 80, height: 80)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 12)
        return cv
    }()

    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
        configureCV()
        tabBarController?.tabBar.isHidden = false
    }

    
    //MARK: - Helpers
    
    func configureUI() {

        view.addSubview(mainLabel)
        view.addSubview(subLabel)
        view.addSubview(mainCetnerView)
        view.addSubview(collectionView)
        
        
        mainLabel.anchor(top:view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,paddingTop: 24 ,paddingLeft: 28,height: 44)
        subLabel.anchor(top:mainLabel.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingLeft: 28,paddingBottom: 5,height: 44)
  
        mainCetnerView.anchor(left: view.leftAnchor,right: view.rightAnchor,paddingTop: 20,height: 234)
        mainCetnerView.center(inView: view)
        mainCetnerView.setDimensions(width: 400, height: 400)
        
        collectionView.anchor(top:mainCetnerView.bottomAnchor,left:view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor,paddingTop: 20,paddingBottom: 27,height: 80)
        
        


        mainCetnerView.delegate = self
        view.backgroundColor = .white
        
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "logo_navbar"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItems = [barButton]
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "inactive_bell"), style: .plain, target: self, action: #selector(handleNotification))
        navigationItem.rightBarButtonItem?.tintColor = .blue500
        
        navigationController?.navigationBar.barTintColor = .white
    }
    
    func configureCV() {
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    

    
    //MARK: -
    
    @objc func handleNotification() {
        let controller = NoticeTableViewController()
        navigationController?.pushViewController(controller, animated: true)
       
    }
    
    @objc func handleQrButton() {
        let controller = QrScannverViewController()
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
}


extension MainViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MainCollectionViewCell
        
        return cell
    }
    
    
    
    
    
}


extension MainViewController : MainCenterViewDelegate {
    func goToScannerView() {
        let controller = QrScannverViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
