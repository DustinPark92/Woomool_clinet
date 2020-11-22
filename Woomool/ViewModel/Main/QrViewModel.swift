//
//  MainViewModel.swift
//  Woomool
//
//  Created by Dustin on 2020/08/27.
//  Copyright © 2020 Woomool. All rights reserved.
//


import UIKit


class QrViewModel {
    
    let color = UIColor()
    
    func NotiView(label: UILabel) -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.anchor(height: 48)
        view.makeAborder(radius: 5)
        

        view.addSubview(label)
    
        label.center(inView: view)
        
        
        return view
    }
    
    
    func popUpView(image: UIImageView, centerlabel : UILabel, confirmButton : UIButton, cancelButton :UIButton , cafeNameLabel : UILabel) -> UIView {
        
        let view = UIView()
        view.backgroundColor = .white
        view.makeAborder(radius: 14)
        view.addSubview(image)
        view.addSubview(centerlabel)
        view.addSubview(confirmButton)
        view.addSubview(cancelButton)
        view.addSubview(cafeNameLabel)
        
        
        image.setDimensions(width: 170, height: 132.5)
        image.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: 53)
        image.image = UIImage(named: "authQR")
        centerlabel.font = UIFont.NotoMedium20
        centerlabel.textColor = .black900
        
        centerlabel.text = "우물 이용권을\n사용 하시겠어요?"
        centerlabel.centerX(inView: view, topAnchor: image.bottomAnchor, paddingTop: 37.5)
        centerlabel.numberOfLines = 0
        centerlabel.textAlignment = .center
        
        
        cafeNameLabel.text = "카페 알파카"
        cafeNameLabel.centerX(inView: view, topAnchor: centerlabel.bottomAnchor,paddingTop: 8)
        cafeNameLabel.font = UIFont.NotoMedium14
        cafeNameLabel.textColor = .blue700
        
        
        
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
        cancelButton.setTitleColor(.bestAsk, for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        
        cancelButton.setTitle("취소", for: .normal)
        confirmButton.setTitle("확인", for: .normal)
        
        return view
    }
    
    func popUpViewConfirm(image: UIImageView, centerlabel : UILabel,countLabel : UILabel, confirmButton : UIButton, cancelButton :UIButton, starRateView : StarRateView,starView :UIView) -> UIView {
        
        let view = UIView()
        view.backgroundColor = .white
        view.makeAborder(radius: 14)
        view.addSubview(image)
        view.addSubview(centerlabel)
        view.addSubview(confirmButton)
        view.addSubview(cancelButton)
        view.addSubview(countLabel)
        starView.addSubview(starRateView)
        view.addSubview(starView)
        image.image = UIImage(named: "compQR")
        
        
        image.setDimensions(width: 100, height: 80)
        image.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: 40)
        centerlabel.font = UIFont.NotoMedium20
        centerlabel.textColor = .black900
        centerlabel.text = "이용권을 사용했습니다\n직원에게 보여주세요"
        centerlabel.centerX(inView: view, topAnchor: image.bottomAnchor, paddingTop: 12)
        centerlabel.numberOfLines = 0
        centerlabel.textAlignment = .center
        
        countLabel.font = UIFont.NotoMedium14
        countLabel.textColor = .blue700
        countLabel.text = "남은 시간 01:00"
        countLabel.centerX(inView: view, topAnchor: centerlabel.bottomAnchor, paddingTop: 8)
        
      
        
        let sv = UIView()
        view.addSubview(sv)
        sv.backgroundColor = .blue
        sv.anchor(top:countLabel.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 11,paddingLeft: 12,paddingRight: 12,height: 0.75)
        
        let ratingLabel = UILabel()
        ratingLabel.textAlignment = .center
        ratingLabel.text = "좋은 우물이었나요?"
        ratingLabel.font = UIFont.NotoMedium14
        ratingLabel.textColor = .black900
        view.addSubview(ratingLabel)
        ratingLabel.centerX(inView: view, topAnchor: sv.bottomAnchor, paddingTop: 14)
        
        
   
        starView.anchor(top:ratingLabel.bottomAnchor,left: view.leftAnchor,paddingTop: 8,paddingLeft: 86)
        starView.setDimensions(width: 120, height: 30)
  
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
        cancelButton.setTitleColor(.bestAsk, for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        
        cancelButton.setTitle("연장하기", for: .normal)
        confirmButton.setTitle("완료", for: .normal)
        
        
        
        
        return view
    }
    

    
 
    
}
