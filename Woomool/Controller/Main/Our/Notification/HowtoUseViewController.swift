//
//  HowtoUserViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/09/19.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

private let reuseIdentifier = "HowToUseCollectionViewCell"

class HowtoUseViewController: UIViewController {
    
    let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
    
        
        return cv
    }()
    
    let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 1
        pc.numberOfPages = 5
        pc.currentPageIndicatorTintColor = .black
        pc.pageIndicatorTintColor = .lightGray
        pc.isEnabled = false
        return pc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    func configureUI() {
        addNavbackButton(selector: #selector(handleDismiss))
        title = "이용 방법"
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        
        view.addSubview(collectionView)

        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HowToUseCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
   
        
        view.addSubview(pageControl)
        pageControl.anchor(top:view.safeAreaLayoutGuide.topAnchor,left: collectionView.leftAnchor ,paddingTop: 20 ,paddingLeft: 24)
        
        collectionView.anchor(top:pageControl.bottomAnchor,left: view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor)
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    @objc func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
    

}


extension HowtoUseViewController : UICollectionViewDelegate, UICollectionViewDataSource  {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let page = Int(targetContentOffset.pointee.x / collectionView.frame.width)
        self.pageControl.currentPage = page
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UsergradeOptions.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HowToUseCollectionViewCell
        let option = HowToUseOption(rawValue: indexPath.row)
        cell.option = option
        return cell

        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
}

extension HowtoUseViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 140)
    }
}
