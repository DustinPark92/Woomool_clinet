//
//  CouponUsingTableViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/09/07.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class CouponUsingTableViewCell: UITableViewCell {
    
    let viewModel = MypageViewModel()
    
    let mainLabel : UILabel = {
        let lb = UILabel()
        lb.text = "쿠폰사용"
        lb.font = UIFont.NotoRegular16
        lb.textColor = .black900
        return lb
    }()
    
    let filterView : UIView = {
        let uv = UIView()
        uv.backgroundColor = .gray200
        uv.makeAborder(radius: 10)
        return uv
    }()
    
    let filterLabel : UILabel = {
        let lb = UILabel()
        lb.text = "사용 가능한 쿠폰"
        lb.textColor = .gray400
        lb.font = UIFont.NotoRegular16
        return lb
    }()
    
    let filterButton : UIButton = {
        let bt = UIButton(type: .system)
        return bt
    }()
    
    let filterImage : UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 14, height: 8)
        iv.image = UIImage(named: "downArrow")
        
        return iv
    }()
    

    let sv : UIView = {
        let uv = UIView()
        uv.backgroundColor = .bestAsk
        return uv
    }()
    
    let sv2 : UIView = {
        let uv = UIView()
        uv.backgroundColor = .bestAsk
        return uv
    }()

    
    lazy var cancelButton : UIButton = viewModel.couponButtonUI(setTitle: "취소", setTitleColor: .blue500, bgColor: .white)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(mainLabel)
        contentView.addSubview(filterView)
        contentView.addSubview(sv)
        contentView.addSubview(sv2)

        contentView.addSubview(cancelButton)
        filterView.addSubview(filterLabel)
        filterView.addSubview(filterButton)
        filterView.addSubview(filterImage)
        sv.anchor(top:topAnchor,left: leftAnchor,right: rightAnchor,height: 6)
        sv2.anchor(left: leftAnchor,bottom: bottomAnchor,right: rightAnchor,height: 6)
        
        
        cancelButton.makeAborderWidth(border: 1, color: UIColor.blue500
                                        .cgColor)
        
        mainLabel.anchor(top:topAnchor,left: leftAnchor,paddingTop: 32,paddingLeft: 32)
        filterView.anchor(top:mainLabel.bottomAnchor,left: leftAnchor,bottom: bottomAnchor,paddingTop: 7,paddingLeft: 32,paddingBottom: 89,width: 246,height: 36)
        filterButton.addConstraintsToFillView(filterView)
        filterLabel.anchor(top:filterView.topAnchor,left: filterView.leftAnchor,paddingTop: 6,paddingLeft: 16)
        filterImage.anchor(top:filterView.topAnchor,right: filterView.rightAnchor,paddingTop:14 ,paddingRight: 14)
        cancelButton.anchor(top:mainLabel.bottomAnchor,left:filterView.rightAnchor,paddingTop: 7, paddingLeft: 7,width: 58,height: 32)
        cancelButton.isHidden = true
        
        
        contentView.setDimensions(width: frame.width, height: 200)
        
    }
    @objc func handleFilter() {
        print(123)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
       print(123)
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
