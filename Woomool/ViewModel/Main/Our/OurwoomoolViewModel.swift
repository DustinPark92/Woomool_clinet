//
//  OurwoomoolViewModel.swift
//  Woomool
//
//  Created by Dustin on 2020/09/12.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit


class OurwoomoolViewModel {
    
    let bestwoomoolImg = ["best_rank_1","best_rank_2","best_rank_3"] 
    let bestWoomoolRank = ["1st","2nd","3rd"]

func attributedButton(_ firstPart: String) -> UIButton {
    let button = UIButton(type: .system)
    let attributedTitle = NSMutableAttributedString(string: firstPart, attributes: [NSAttributedString.Key.font :UIFont.NotoMedium12!,NSAttributedString.Key.foregroundColor: UIColor.white])
           
 
    
    button.setAttributedTitle(attributedTitle, for: .normal)
    
    
    return button
}


}
