//
//  HistoryDateTableViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/09/08.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class HistoryDateTableViewCell: UITableViewCell {
    
    let mainView : UIView = {
        let uv = UIView()
        uv.backgroundColor = .white
        uv.anchor(height: 44)
        return uv
    }()
    
    let leftButton : UIButton = {
        let bt = UIButton()
        bt.setDimensions(width: 24, height: 24)
        bt.setImage(UIImage(named: "left_arrow"), for: .normal)
        return bt
    }()
    
    let rightButton : UIButton = {
        let bt = UIButton()
        bt.setDimensions(width: 24, height: 24)
        bt.setImage(UIImage(named: "right_arrow"), for: .normal)
        return bt
    }()
    
    let dateLabel : UILabel = {
        let lb = UILabel()
        lb.text = "2020.08"
        lb.textColor = .black900
        lb.font = UIFont.NotoMedium14
        return lb
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(mainView)
        mainView.anchor(top:topAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor)
        
        mainView.addSubview(leftButton)
        mainView.addSubview(rightButton)
        mainView.addSubview(dateLabel)
        
        leftButton.anchor(top:mainView.topAnchor,left: mainView.leftAnchor,paddingTop:10 ,paddingLeft:24 )
        rightButton.anchor(top:mainView.topAnchor,right: mainView.rightAnchor,paddingTop:10 ,paddingRight :24 )
        dateLabel.centerX(inView: mainView, topAnchor: mainView.topAnchor, paddingTop: 9.17)
 
        
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
