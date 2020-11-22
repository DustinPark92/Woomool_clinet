//
//  MypageHistoryFilterView.swift
//  Woomool
//
//  Created by Dustin on 2020/09/08.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit


private let reuseIdentifier = "HistoryFilterCollectionViewCell"


protocol MypageHistoryFilterViewDelegate : class {
    func filterView(_ view: MypageHistoryFilterView, didselect indexPath : Int)
}


class MypageHistoryFilterView: UIView {
    //MARK : - Properteis
    
    weak var delegate : MypageHistoryFilterViewDelegate?
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero
            , collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
    
        return cv
    }()
    
    

    

    //MARK : - LifeCycles
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
 
        
        collectionView.register(HistoryFilterCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .left)
        
    
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {

    }
    
    
}


//MARK : - UICollectionViewDataSource
extension MypageHistoryFilterView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MypageHistroyOption.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HistoryFilterCollectionViewCell
        let option = MypageHistroyOption(rawValue: indexPath.row)
        cell.option = option
        return cell

    }

}
//MARK : - UICollectionViewDelegate
extension MypageHistoryFilterView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count = CGFloat(MypageFilterOptions.allCases.count)
        return CGSize(width: frame.width / count, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    

    
    
}
//MARK : - UICollectionViewFlowLayOut
extension MypageHistoryFilterView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)

        delegate?.filterView(self, didselect: indexPath.row)
    }
  

}
