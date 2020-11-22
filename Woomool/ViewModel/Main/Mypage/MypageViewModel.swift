//
//  MypageViewModel.swift
//  Woomool
//
//  Created by Dustin on 2020/08/27.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

enum MypageFilterOptions : Int, CaseIterable {
    case my
    case history
    case buy
    
    var description: String{
        switch self {
        case .my:
            return "나의 환경"
        case .history:
            return "이용 내역"
        case .buy:
            return "이용권 구매"
        }
    }
}


enum MypageHistroyOption : Int, CaseIterable {
    case All
    case history
    case pay
    
    var description: String{
        switch self {
        case .All:
            return "전체 보기"
        case .history:
            return "이용 내역"
        case .pay:
            return "이용권 결제"
        }
    }
}


class MypageViewModel {
    
    let color = UIColor()
    let couponTopLabelList = ["구매","사용","잔여"]
    var couponCount = [12,1,11]
    let couponImage = ["buy_mypage","use_mypage","coupon_mypage"]
    var seperatorView = true
    var i = 0
    var couponSelected = 0
    
    
    func CouponView(topLabel : UILabel, bottomLabel: UILabel, imageView : UIImageView,sv : UIView ) -> UIView {
        let view = UIView()
        
        view.backgroundColor = .white
        view.anchor(height: 90)
        view.makeAborder(radius: 5)
        
        view.addSubview(topLabel)
        view.addSubview(bottomLabel)
        view.addSubview(imageView)
        
        topLabel.textAlignment = .center
        bottomLabel.textAlignment = .center
        

        
        view.addSubview(sv)
        sv.anchor(top:view.topAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,paddingTop: 6,paddingBottom: 7,width: 0.75)
        sv.backgroundColor = UIColor.blue500

        
        imageView.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: 8)
        topLabel.centerX(inView: view, topAnchor: imageView.bottomAnchor, paddingTop: -4)
        bottomLabel.centerX(inView: view, topAnchor: topLabel.bottomAnchor, paddingTop: 0)
        
        
        return view
    }
    
    func inviteCenterView(inviteCodeLabel : UILabel) -> UIView {
        let view = UIView()
        view.backgroundColor = .gray100
        view.makeAborderWidth(border: 1, color: UIColor.gray200.cgColor)
        view.makeAborder(radius: 14)
        
        let topLabel = UILabel()
        view.addSubview(topLabel)
        topLabel.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: 16)
        topLabel.textAlignment = .center
        topLabel.text = "내 추천인 코드"
        topLabel.font = UIFont.NotoMedium14
        topLabel.textColor = UIColor.black900
        
        view.addSubview(inviteCodeLabel)
        inviteCodeLabel.centerX(inView: view, topAnchor: topLabel.bottomAnchor, paddingTop: 4)
        inviteCodeLabel.textColor = .black900
        inviteCodeLabel.text = "ABC123"
        inviteCodeLabel.textAlignment = .center
        inviteCodeLabel.font = UIFont.RobotoBold20
        
        
        
        return view
    }
    
    func inputContainerView(textField: UITextField, sv : UIView) -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        
        view.addSubview(textField)
        textField.anchor(top:view.topAnchor,left: view.leftAnchor,right:view.rightAnchor,paddingLeft: 8,paddingBottom: 6)
        textField.setDimensions(width: 24, height: 30)
        textField.textColor = .black900
        textField.font = UIFont.NotoBold16

        view.addSubview(sv)
        
        
        
        sv.backgroundColor = .blue500
        sv.anchor(top:textField.bottomAnchor,left:view.leftAnchor,right:view.rightAnchor,paddingTop: 6,paddingLeft:8,height: 2)
        return view
    }
    
    func textField(_ text : String) -> UITextField {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray350,NSAttributedString.Key.font : UIFont.NotoRegular16!])
        
        
        return tf
    }
    
    func couponButtonUI(setTitle title: String, setTitleColor : UIColor , bgColor : UIColor) -> UIButton {
        
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue500
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.anchor(height:36)
        button.titleLabel?.font = UIFont.NotoMedium14
        button.setTitleColor(setTitleColor, for: .normal)
        button.backgroundColor = bgColor

        return button
    }
    
    func payButtonUI(setTitle title: String) -> UIButton {
        
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue500
        button.anchor(height:56)
        button.titleLabel?.font = UIFont.NotoBold18

        return button
    }
    
    func popUpView(centerlabel : UILabel, confirmButton : UIButton, cancelButton :UIButton) -> UIView {
        
        let view = UIView()
        view.backgroundColor = .white
        view.makeAborder(radius: 5)
        view.addSubview(centerlabel)
        view.addSubview(confirmButton)
        view.addSubview(cancelButton)
        

        centerlabel.font = UIFont.NotoMedium20
        centerlabel.text = "휴대폰 번호 변경을 위해 \n 본인 인증 페이지로 \n 이동합니다."
        centerlabel.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: 82)
        centerlabel.numberOfLines = 0
        centerlabel.textAlignment = .center
        
        
        let stack = UIStackView(arrangedSubviews: [cancelButton,confirmButton])
        
        view.addSubview(stack)
        stack.anchor(left:view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,height: 50)
        stack.alignment = .fill
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
        confirmButton.backgroundColor = .blue500
        cancelButton.backgroundColor = .gray300
        cancelButton.titleLabel?.font = UIFont.NotoBold18
        confirmButton.titleLabel?.font = UIFont.NotoBold18
        cancelButton.titleLabel?.textColor = .lightGray
        cancelButton.setTitle("취소", for: .normal)
        confirmButton.setTitle("확인", for: .normal)
        
        return view
    }
    
    
    func DetailattributedButton(_ firstPart: String) -> UIButton {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: firstPart, attributes: [NSAttributedString.Key.font :UIFont.NotoMedium12,NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedTitle.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, firstPart.count))
               
     
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        
        return button
    }
    
    
    func couponPopUpView(collectionView : UICollectionView, usingRule : UILabel,usingRuleDeatil : UILabel, confirmButton : UIButton, cancelButton :UIButton) -> UIView {
        
        let view = UIView()
        view.backgroundColor = .white
        view.makeAborder(radius: 5)
        view.addSubview(collectionView)
        view.addSubview(usingRule)
        view.addSubview(usingRuleDeatil)
        view.addSubview(confirmButton)
        view.addSubview(cancelButton)
        
        collectionView.anchor(top:view.topAnchor,left: view.leftAnchor,right: view.rightAnchor,height: 150)
        
        usingRule.anchor(top:collectionView.bottomAnchor,left: view.leftAnchor,paddingTop: 26,paddingLeft: 16)
        usingRule.textColor = .black900
        usingRule.font = UIFont.NotoRegular16
        usingRule.text = "사용조건"
        
        usingRuleDeatil.anchor(top:usingRule.bottomAnchor,left: view.leftAnchor,paddingTop: 6,paddingLeft: 16)
        usingRuleDeatil.numberOfLines = 0
        usingRuleDeatil.textColor = .black400
        usingRuleDeatil.font = UIFont.NotoRegular16
        
        usingRuleDeatil.text =
        "- 타쿠폰 중복할인 불가능\n- 월요일에만 사용가능\n- 1회성 쿠폰으로 사용시 소멸됩니다. "
        

        let stack = UIStackView(arrangedSubviews: [cancelButton,confirmButton])
        
        view.addSubview(stack)
        stack.anchor(left:view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,height: 50)
        stack.alignment = .fill
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
        confirmButton.backgroundColor = .blue500
        cancelButton.backgroundColor = .gray300
        cancelButton.setTitle("닫기", for: .normal)
        confirmButton.setTitle("사용하기", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        cancelButton.setTitleColor(.cancelGray, for: .normal)
        confirmButton.titleLabel?.font = UIFont.NotoBold18
        cancelButton.titleLabel?.font = UIFont.NotoBold18
        
        return view
    }

    
 
    
}
