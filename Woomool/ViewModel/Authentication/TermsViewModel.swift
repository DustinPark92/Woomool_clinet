//
//  TermsViewModel.swift
//  Woomool
//
//  Created by Dustin on 2020/10/30.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit


struct TermsViewModel {
    
    //MARK: - Properties
    var termList = [TermsModel]()
    
    
    var serviceAuth : Bool {
        if let auth = UserDefaults.standard.object(forKey: termList[0].termsId) {
            return auth as! Bool
        }
        return false
    }
    var privacyAuth : Bool {
        if let auth = UserDefaults.standard.object(forKey: termList[1].termsId) {
            return auth as! Bool
        }
        return false
    }
    var locationAuth : Bool {
        if let auth = UserDefaults.standard.object(forKey: termList[2].termsId) {
            return auth as! Bool
        }
        return false
    }
    
    var allAuth : Bool {
        if let auth = UserDefaults.standard.object(forKey: "All") as? Bool {
            return auth
        }
        
        return false
    }
    

    
}
