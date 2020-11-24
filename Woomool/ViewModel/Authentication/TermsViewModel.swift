//
//  TermsViewModel.swift
//  Woomool
//
//  Created by Dustin on 2020/10/30.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit


class TermsViewModel {
    
    
    var allAuthValid = false
    
    
    var termsCountArray : Array<String> = []

    
    lazy var  detilAllAuthValid : Bool = {
        if allAuthValid {
            return true
        }
       return false
    }()
    
    
    
    

    func allButtonCliecked() -> UIImage{
        var imageName = ""
        if allAuthValid {
            allAuthValid = false
            imageName = "check_inactive"
            return UIImage(named: imageName)!
        } else {
            allAuthValid = true
            imageName = "check_active"
            return UIImage(named: imageName)!
        }
        
    }
    
    func allButtonConfirmButton() -> UIColor{

        if allAuthValid {
            return UIColor.blue500
        } else {
            return UIColor.gray300
        }
    }
    
    func allButtonConfirmButtonIsEnable() -> Bool{

        if allAuthValid {
            return true
        } else {
            return false
    }
        
    }
    
    
    func termsCountArrayValid(termsModel : [TermsModel] ,count : Int){

    if allAuthValid {
        termsCountArray.removeAll()
        for item in termsModel {
            termsCountArray.append(item.termsId)
        }
        } else {
            termsCountArray = Array<String>(repeating: "", count: count)
    }
        
    }
}
