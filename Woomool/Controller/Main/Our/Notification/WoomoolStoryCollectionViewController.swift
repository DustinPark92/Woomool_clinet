//
//  WoomoolStoryCollectionViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/09/19.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit


class WoomoolStoryViewController: UIViewController {
    
    let collectioView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        cv.isPagingEnabled = true
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCV()
      

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    func configureUI() {
        title = "우물 이야기"
        view.backgroundColor = .white
        addNavbackButton(selector: #selector(handleDismiss))
        view.addSubview(collectioView)
        collectioView.anchor(top:view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,right:view.rightAnchor)
    }
    
    func configureCV() {
        collectioView.register(WoomoolImageCell.self, forCellWithReuseIdentifier: "WoomoolImageCell")
        collectioView.delegate = self
        collectioView.dataSource = self
    }
    

    
    @objc func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }


    
}


extension  WoomoolStoryViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item
        {
        case 0...9:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WoomoolImageCell", for: indexPath) as! WoomoolImageCell
            cell.imageView.image = UIImage(named: "contents\(indexPath.item + 1)")
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    
    
}


extension WoomoolStoryViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
