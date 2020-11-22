//
//  MyPageCollectionReusableView.swift
//  Woomool
//
//  Created by Dustin on 2020/08/27.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

private let topCellIdentifier = "MyCouponListCollectionViewCell"


class MyPageCollectionReusableView: UICollectionReusableView {
    
    var userModel: UserModel? {
        didSet {
            nameLabel.text = userModel?.nickname
        }
    }
    
    
    var topLayout = UICollectionViewFlowLayout()
    let viewModel = MypageViewModel()
    
    
    
    let filterBar = MypageFilterView()
    let tableView = UITableView()
    
    let nameLabel : UILabel = {
        let lb = UILabel()
        lb.text = "일리님"
        lb.font = UIFont.NotoMedium26
        lb.textColor = .black900
        return lb
    }()
    
    let nextBtn : UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "right_arrow"), for: .normal)
        bt.setDimensions(width: 32, height: 32)
        bt.tintColor = .black
        return bt
    }()
    
    let settingBtn : UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "setting"), for: .normal)
        bt.setDimensions(width: 32, height: 32)
        bt.tintColor = .black
        return bt
    }()
    
    let userRank : UILabel = {
        let lb = UILabel()
        lb.text = "샘 회원입니다."
        lb.font = UIFont.NotoMedium14
        lb.textColor = .black400
        return lb
    }()
    
     let userRankQuestionMarkImg : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "questionMark")
        return iv
    }()
    
     let friendInviteButton : UIButton = {
        let bt = UIButton()
        bt.setTitle("친구 초대", for: .normal)
        bt.setTitleColor(UIColor.black400, for: .normal)
        bt.titleLabel?.textColor = UIColor.black400
        bt.titleLabel?.font = UIFont.NotoMedium12
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        bt.setDimensions(width: 65, height: 22)
        bt.makeAborder(radius: 6)
        bt.makeAborderWidth(border: 1, color: UIColor.black400.cgColor)
        return bt
    }()
    
     let userCouponListLabel : UILabel = {
        let lb = UILabel()
        lb.text = "이용권 현황"
        lb.textColor = .black900
        lb.font = UIFont.NotoMedium14
        return lb
    }()
    
     lazy var collectionViewTop : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(nameLabel)
        addSubview(nextBtn)
        addSubview(settingBtn)
        addSubview(userRank)
        addSubview(friendInviteButton)
        addSubview(userCouponListLabel)
        addSubview(collectionViewTop)
        addSubview(userRankQuestionMarkImg)
        addSubview(tableView)
        
        nameLabel.anchor(top:topAnchor,left: leftAnchor,paddingTop: 32,paddingLeft: 32)
        nextBtn.anchor(top:topAnchor,left: nameLabel.rightAnchor,paddingTop:35,paddingLeft: 1)
        settingBtn.anchor(top:topAnchor,right: rightAnchor,paddingTop: 12,paddingRight:30.8)
        
        
        
        userRank.anchor(top:nameLabel.bottomAnchor,left: leftAnchor,paddingTop: 4,paddingLeft: 32)
        userRankQuestionMarkImg.anchor(top:nextBtn.bottomAnchor,left: userRank.rightAnchor,paddingTop: 11,paddingRight: 4)
        
        friendInviteButton.anchor(top:topAnchor,right: rightAnchor,paddingTop: 72,paddingRight: 32)
        
        userCouponListLabel.anchor(top:userRank.bottomAnchor,left: leftAnchor,paddingTop: 32,paddingLeft: 32)
        
        configureCV()
        collectionViewTop.anchor(top:userCouponListLabel.bottomAnchor,left: leftAnchor,right: rightAnchor,paddingTop: 4,paddingLeft: 32,paddingRight: 31,width: frame.width - 63,height: 90)
        collectionViewTop.register(MyCouponListCollectionViewCell.self, forCellWithReuseIdentifier: topCellIdentifier)
        collectionViewTop.delegate = self
        collectionViewTop.dataSource = self
        

        
    }
    
    func configureCV() {
        topLayout.itemSize = CGSize(width: (frame.width - 63) / 3
            , height: 90)
        topLayout.minimumInteritemSpacing = 0
        topLayout.minimumLineSpacing = 0
        collectionViewTop.collectionViewLayout = topLayout
        collectionViewTop.makeAborderWidth(border: 1, color: UIColor.blue500.cgColor.copy(alpha: 0.5)!)
        collectionViewTop.makeAborder(radius: 14)
        
       
  
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension MyPageCollectionReusableView : UICollectionViewDelegate,UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.couponCount.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: topCellIdentifier, for: indexPath) as! MyCouponListCollectionViewCell
        cell.couponImg.image = UIImage(named: viewModel.couponImage[indexPath.row])
        cell.couponLabel.text = viewModel.couponTopLabelList[indexPath.row]
        cell.coupongCount.text = "\(viewModel.couponCount[indexPath.row])"
        if indexPath.row == 2 {
            cell.sv.isHidden = true
        }
        cell.backgroundColor = .white
        return cell
    }
    

    
    
}



