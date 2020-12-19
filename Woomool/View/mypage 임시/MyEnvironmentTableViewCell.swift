//
//  MyEnvironmentTableViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/09/07.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class MyEnvironmentTableViewCell: UITableViewCell {

    
    let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return cv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .bestAsk
        collectionView.backgroundColor = .bestAsk
        
        addSubview(collectionView)
        collectionView.anchor(top:topAnchor,left:leftAnchor,bottom: bottomAnchor,right: rightAnchor,paddingTop: 16,paddingLeft: 16,paddingBottom: 16,paddingRight: 16)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MyEnvirCell1.self, forCellWithReuseIdentifier: "MyEnvirCell1")
        collectionView.register(MyEnvirCell2.self, forCellWithReuseIdentifier: "MyEnvirCell2")
        
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


extension MyEnvironmentTableViewCell : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyEnvirCell1", for: indexPath) as! MyEnvirCell1
            
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyEnvirCell1", for: indexPath) as! MyEnvirCell1
            cell.mainImageView.image = UIImage(named: "")
            cell.mainImageView.backgroundColor = .white
            cell.mainLabel.textColor = .black400
            cell.mainLabel.text = "우리의 일회용 컵 소비 억제 횟수"
            cell.subLabel.text = "100,000회"
            cell.subLabel.textColor = .black900
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyEnvirCell2", for: indexPath) as! MyEnvirCell2
            return cell
        default:
            break
        }

        return UICollectionViewCell()
    }
    
    
    
    
}


extension MyEnvironmentTableViewCell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 2 {
            return CGSize(width: collectionView.frame.width, height: 130)
        }
        return CGSize(width: collectionView.frame.width, height: 84)
    }
}
