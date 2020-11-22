//
//  WoomoolServiceTableViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/09/18.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class WoomoolServiceTableViewCell: UITableViewCell {
    
    let viewModel = MyWoomoolViewModel()
    
    var option: WoomoolService! {
        didSet { mainLabel.text = option.title
            TextField.placeholder = option.placeHolder
        }
    }

    let mainLabel : UILabel = {
        let lb = UILabel()
        lb.text = "카페 이르"
        lb.font = UIFont.NotoBold16
        lb.textColor = .black900
        return lb
    }()
    
    
    lazy var ContainerView: UIView = {
        let view = viewModel.inputContainerView(textField: TextField, sv: sv)
        return view
        
    }()
    
    var sv = UIView()


    lazy var TextField : UITextField = viewModel.textField()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(mainLabel)
        contentView.addSubview(ContainerView)


        mainLabel.anchor(top:topAnchor,left: leftAnchor,paddingTop: 32,paddingLeft: 50)
        ContainerView.anchor(top:mainLabel.bottomAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor,paddingTop: 8 ,paddingLeft: 41,paddingBottom: 10,paddingRight: 39)
        
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    

}
