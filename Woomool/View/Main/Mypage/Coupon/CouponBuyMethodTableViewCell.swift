//
//  CouponBuyMethodTableViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/12/13.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit


protocol CouponBuyMethodTableViewCellDelegate : class{
    func paymentMethodSelecte(index : Int)
}

class CouponBuyMethodTableViewCell: UITableViewCell {
    
    weak var delegate : CouponBuyMethodTableViewCellDelegate?
    
    private let mainLabel : UILabel = {
        let lb = UILabel()
        lb.text = "결제 수단"
        lb.font = UIFont.NotoBold16
        lb.textColor = .black900
        return lb
    }()
    
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        cv.delegate = self
        cv.dataSource = self
        layout.scrollDirection = .vertical
        
        
        return cv
    }()
    
    let privacyLabel : UILabel = {
        let lb = UILabel()
        lb.text = "개인정보 제3자 제공 내용 확인하였으며, 결제에 동의합니다."
        lb.textColor = .black400
        lb.font = UIFont.NotoMedium12
        return lb
    }()
    
    let sv : UIView = {
        let uv = UIView()
        uv.backgroundColor = .bestAsk
        return uv
    }()
    
    lazy var payButton : UIButton = MypageViewModel().payButtonUI(setTitle: "결제하기")
    
    var methodSelected = ""
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        contentView.addSubview(mainLabel)
        mainLabel.anchor(top:topAnchor,left: leftAnchor,paddingTop:32 ,paddingLeft: 17)
        
        contentView.addSubview(collectionView)
        collectionView.anchor(top:mainLabel.bottomAnchor,left: leftAnchor,right: rightAnchor,paddingTop: 12)
        
        contentView.addSubview(sv)
        contentView.addSubview(privacyLabel)
        contentView.addSubview(payButton)
        
        sv.anchor(top:collectionView.bottomAnchor,left:leftAnchor,right: rightAnchor,paddingTop: 32, height: 8)
        
        privacyLabel.centerX(inView: self, topAnchor: sv.bottomAnchor, paddingTop: 16)
        
        
        payButton.anchor(top:privacyLabel.bottomAnchor,left:leftAnchor,bottom: bottomAnchor,right: rightAnchor,paddingTop: 41)
        
        
        
        collectionView.register(CouponBuyMethodCollectionViewCell.self, forCellWithReuseIdentifier: "CouponBuyMethodCollectionViewCell")
        collectionView.backgroundColor = .white
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        collectionView.reloadData()
        // Configure the view for the selected state
    }

}


extension CouponBuyMethodTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PaymethodList.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CouponBuyMethodCollectionViewCell", for: indexPath) as! CouponBuyMethodCollectionViewCell
        cell.mainLabel.text = PaymethodList.init(rawValue: indexPath.item)?.description
        cell.mainImageView.image =  PaymethodList.init(rawValue: indexPath.item)!.inactiveImage


        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.paymentMethodSelecte(index: indexPath.item)
        
    }
    
    
    
    
}


extension CouponBuyMethodTableViewCell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 2.2, height: 56)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 9)
    }
    
    
}
