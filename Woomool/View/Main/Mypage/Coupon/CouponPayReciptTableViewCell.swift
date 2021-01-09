//
//  CouponPayReciptTableViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/09/07.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class CouponPayReciptTableViewCell: UITableViewCell {
    
    let viewModel = MypageViewModel()
    
    let mainLabel : UILabel = {
        let lb = UILabel()
        lb.text = "결제내역"
        lb.font = UIFont.NotoBold16
        return lb
    }()
    
    let dotSv : UIView = {
        let uv = UIView()
        uv.makeDashedBorderLine()
        return uv
    }()
    
    let sv : UIView = {
        let uv = UIView()
        uv.backgroundColor = .black
        return uv
    }()
    
    let sv2 : UIView = {
        let uv = UIView()
        uv.backgroundColor = .bestAsk
        return uv
    }()
    
    let priceTitle : UILabel = {
        let lb = UILabel()
        lb.text = "이용권"
        lb.font = UIFont.NotoMedium14
        lb.textColor = .black900
        return lb
        
    }()
    
    let priceLabel : UILabel = {
        let lb = UILabel()
        lb.text = "9,900원"
        lb.font = UIFont.NotoMedium20
        lb.textColor = .gray400
        return lb
    }()
    
    
    let discountLabel : UILabel = {
        let lb = UILabel()
        lb.text = "할인"
        lb.font = UIFont.NotoMedium14
        lb.textColor = .black900
        return lb
    }()
    
    let discountPriceLabel : UILabel = {
        let lb = UILabel()
        lb.text = "-1000원"
        lb.font = UIFont.NotoMedium20
        lb.textColor = .gray400
        return lb
    }()
    
    let usingLabel : UILabel = {
        let lb = UILabel()
        lb.text = "이용횟수"
        lb.font = UIFont.NotoMedium14
        return lb
    }()
    
    let usingCountLabel : UILabel = {
        let lb = UILabel()
        lb.font = UIFont.NotoMedium20
        lb.textColor = .blue500
        return lb
    }()
    
    
    
    let totalLabel : UILabel = {
        let lb = UILabel()
        lb.text = "총"
        lb.font = UIFont.NotoMedium14
        lb.textColor = .black900
        return lb
        
    }()
    
    let totalPriceLabel : UILabel = {
        let lb = UILabel()
        lb.text = "9,900원"
        lb.font = UIFont.NotoMedium20
        lb.textColor = .black900
        return lb
    }()
    
    

    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(mainLabel)
        contentView.addSubview(dotSv)
        contentView.addSubview(priceLabel)
        contentView.addSubview(priceTitle)
        contentView.addSubview(discountLabel)
        contentView.addSubview(discountPriceLabel)
        contentView.addSubview(usingLabel)
        contentView.addSubview(usingCountLabel)
        contentView.addSubview(sv)
        contentView.addSubview(totalLabel)
        contentView.addSubview(totalPriceLabel)
        contentView.addSubview(sv2)
        

        
        mainLabel.anchor(top:topAnchor,left:leftAnchor,paddingTop: 32,paddingLeft: 17)
       
        dotSv.anchor(top:mainLabel.bottomAnchor,left: leftAnchor,paddingTop:24 ,paddingLeft:32,width: 300,height: 1)
        priceTitle.anchor(top:mainLabel.bottomAnchor,left: leftAnchor,paddingTop:14 ,paddingLeft:16)
        priceLabel.anchor(top:mainLabel.bottomAnchor,right: rightAnchor,paddingTop:10 ,paddingRight:17,height: 30)
        discountLabel.anchor(top:priceTitle.bottomAnchor,left: leftAnchor,paddingTop:26 ,paddingLeft: 14)
        discountPriceLabel.anchor(top:priceLabel.bottomAnchor,right: rightAnchor,paddingTop:18 ,paddingRight: 17,height: 30)
        usingLabel.anchor(top:discountLabel.bottomAnchor,left: leftAnchor,paddingTop:26 ,paddingLeft: 16,height: 30)
        usingCountLabel.anchor(top:discountPriceLabel.bottomAnchor,right: rightAnchor,paddingTop:18 ,paddingRight: 17)
        
        sv.anchor(top:usingCountLabel.bottomAnchor,left: leftAnchor,right: rightAnchor,paddingTop:12 ,paddingLeft:31,paddingRight: 34,width: frame.width - 65, height: 1)
        
        totalLabel.anchor(top:sv.bottomAnchor,left: leftAnchor,paddingTop:8 ,paddingLeft:16)
        totalPriceLabel.anchor(top:sv.bottomAnchor,right: rightAnchor,paddingTop:8 ,paddingRight:16)
        
        sv2.anchor(top:totalPriceLabel.bottomAnchor,left: leftAnchor,right: rightAnchor,paddingTop:38,height: 6)

        
        
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
        
        // Configure the view for the selected state
    }
    
}
