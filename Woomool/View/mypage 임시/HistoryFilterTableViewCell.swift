//
//  HistoryFilterTableViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/09/08.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class HistoryFilterTableViewCell: UITableViewCell {
    
    let filterView = MypageHistoryFilterView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(filterView)
        filterView.anchor(top:topAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor)
        
        
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
