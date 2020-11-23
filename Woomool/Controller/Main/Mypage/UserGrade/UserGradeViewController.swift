//
//  UserGradeViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/09/19.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

private let reuseIdentifier = "UserGradeCollectionViewCell"

class UserGradeViewController: UIViewController {
    
    let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        layout.scrollDirection = .horizontal
    
        
        return cv
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = viewModel.firstPage
        pc.numberOfPages = 5
        pc.currentPageIndicatorTintColor = .black
        pc.pageIndicatorTintColor = .lightGray
        pc.isEnabled = false
        return pc
    }()
    
    let noticeLabel : UILabel = {
        let lb = UILabel()
        lb.font = UIFont.NotoMedium12
        lb.textColor = .black400
        lb.text = "모든 활동은 일주일 내에 등급에 반영됩니다."
        return lb
    }()
    
    var userRankModel = [UserRankModel]()
    var index = 3
    var viewModel = UserGradeViewModel()
    var onceOnly = false
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        callRequest()

    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 
 
    }
    
    func callRequest() {
        Request.shared.getUserRank { json in
            print(json)
            
            for item in json.array! {
                let userRankItem = UserRankModel(levelId: item["levelId"].stringValue, name: item["name"].stringValue, orders: item["orders"].intValue, benefits: item["benefits"].stringValue, userStatus: item["userStatus"].stringValue, userRate: item["userRate"].intValue)
                

                    

                self.userRankModel.append(userRankItem)
            }
            

            self.collectionView.reloadData()

            self.collectionView.reloadData()
            self.collectionView.layoutIfNeeded()

            self.collectionView.scrollToItem(at: IndexPath(item: self.viewModel.firstPage, section: 0), at: .right, animated: true)

            
        }
    }
    
    func configureUI() {
        addNavbackButton(selector: #selector(handleDismiss))
        title = "회원 등급"
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        
        view.addSubview(collectionView)
        collectionView.addSubview(pageControl)
        pageControl.anchor(top:view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor ,paddingTop: 30 ,paddingLeft:40)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UserGradeCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.anchor(top:view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor)
        //collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        
        view.addSubview(noticeLabel)
        noticeLabel.centerX(inView: view)
        noticeLabel.anchor(bottom:view.safeAreaLayoutGuide.bottomAnchor,paddingBottom: 20)
        
    }
    
    @objc func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
    

}


extension UserGradeViewController : UICollectionViewDelegate, UICollectionViewDataSource  {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int((targetContentOffset.pointee.x) / collectionView.frame.width)
        self.pageControl.currentPage = page + viewModel.firstPage
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userRankModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserGradeCollectionViewCell
        //initaillize
        cell.trackLayer.isHidden = false
        cell.shapeLayer.isHidden = false
        cell.userNowImg.isHidden = false
        cell.userLockImg.isHidden = false
        cell.userGradeimg.backgroundColor = .gray300
        cell.userNowImg.image = UIImage(named: "")
        
        let item = userRankModel[indexPath.row]
        cell.userLockImg.isHidden = true
        if item.userStatus == "LOCK" {
            cell.trackLayer.isHidden = true
            cell.shapeLayer.isHidden = true
            cell.userNowImg.isHidden = true
            cell.userGradeimg.backgroundColor = .gray400
            cell.userLockImg.isHidden = false
        } else if item.userStatus == "NOW" {

            viewModel.firstPage = indexPath.row

            cell.trackLayer.isHidden = false
            cell.shapeLayer.isHidden = false
            cell.userNowImg.isHidden = false
            cell.userLockImg.isHidden = true
            cell.userNowImg.image = UIImage(named: "now")
            cell.userGradeimg.backgroundColor = .gray300
        } else if item.userStatus == "CLEAR" {
            cell.trackLayer.isHidden = true
            cell.shapeLayer.isHidden = true
            cell.userNowImg.isHidden = false
            cell.userNowImg.image = UIImage(named: "clear")
            cell.userLockImg.isHidden = true
            cell.userGradeimg.backgroundColor = .gray300
        }
        
       
        
        
        cell.userGradeimg.image = UsergradeOptions.init(rawValue: indexPath.row)!.gradeImage
        cell.benefitLabel.text = item.benefits
        cell.levelNameLabel.text = "\(item.levelId) \(item.name)"
        

        return cell

        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        
    }
    
    
    
}

extension UserGradeViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 140)
    }
}
