//
//  MypageFilterViewCollectionViewCell.swift
//  Woomool
//
//  Created by Dustin on 2020/09/03.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ProfileFilterCell"
private let reuseDetailIdentifier = "MyPageDetailCollectionReusableView"

protocol MypageFilterViewDelegate : class {
    func filterView(_ view: MypageFilterView, didselect indexPath : Int)
}


class MypageFilterView: UIView {
    //MARK : - Properteis
    
    weak var delegate : MypageFilterViewDelegate?
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero
            , collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black900
        
       return view
    }()
    

    

    //MARK : - LifeCycles
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
 
        
        collectionView.register(MypageFilterCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .left)
        
    
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        addSubview(underlineView)
        underlineView.anchor(left:leftAnchor,bottom: bottomAnchor,width: frame.width / 3 , height:  2)
    }
    
    
}


//MARK : - UICollectionViewDataSource
extension MypageFilterView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MypageFilterOptions.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MypageFilterCell
        let option = MypageFilterOptions(rawValue: indexPath.row)
        cell.option = option
        return cell

    }

}
//MARK : - UICollectionViewDelegate
extension MypageFilterView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count = CGFloat(MypageFilterOptions.allCases.count)
        return CGSize(width: frame.width / count, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    

    
    
}
//MARK : - UICollectionViewFlowLayOut
extension MypageFilterView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        let xPosition = cell?.frame.origin.x ?? 0
        
        UIView.animate(withDuration: 0.3) {
        self.underlineView.frame.origin.x = xPosition
        }
        


        
        delegate?.filterView(self, didselect: indexPath.row)
    }
  

}
