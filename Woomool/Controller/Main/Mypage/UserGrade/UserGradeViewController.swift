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
    var index = 0
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
        
        viewModel.callRequest {
            self.collectionView.layoutIfNeeded()
            self.collectionView.reloadData()
            self.pageControl.currentPage = self.viewModel.index
            self.collectionView.scrollToItem(at: IndexPath(item: self.viewModel.index, section: 0), at: .right, animated: false)
        } fail: { error in
            self.showOkAlert(title:  "[\(error.status)] \(error.code)=\(error.message)", message: "") {
                
            }
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
        self.pageControl.currentPage = page
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.userRankModel.count
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
        
        let item = viewModel.userRankModel[indexPath.row]
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
        cell.conditionLabel.text = item.standard
        cell.viewModel = viewModel
        
        
        
        //circular Path
        cell.circularPathMain = UIBezierPath(arcCenter: CGPoint(x:70,y:70), radius: 82,
                                            startAngle: -CGFloat.pi/2, endAngle: 2*(CGFloat.pi)*(CGFloat(self.viewModel.percentage)/100) - CGFloat.pi/2,
                                            clockwise: true)
        cell.shapeLayer.backgroundColor = UIColor.white.cgColor
        cell.shapeLayer.strokeEnd = 0
        cell.shapeLayer.path = cell.circularPathMain.cgPath
        cell.shapeLayer.fillColor = UIColor.clear.cgColor
        cell.shapeLayer.lineCap = CAShapeLayerLineCap.round
        cell.shapeLayer.strokeColor = UIColor.blue500.cgColor
        cell.shapeLayer.lineWidth = 5
        
        
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        cell.shapeLayer.add(basicAnimation, forKey: "urSoBasic")
        print("퍼센티지는?...\(item.userRate)")
        
        

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
