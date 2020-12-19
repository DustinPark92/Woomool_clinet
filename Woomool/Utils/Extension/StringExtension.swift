//
//  StringExtension.swift
//  Woomool
//
//  Created by Dustin on 2020/08/26.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

extension String {
    func isValidEmailAddress(email: String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailTest = NSPredicate(format:"SELF MATCHES %@", "\(emailRegEx)m")
        
        return emailTest.evaluate(with: email)
    
    }
    
    func validatePassword() -> Bool {
        let passwordRegEx = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z])(?!.[^a-zA-Z0-9@#${'$'}^+=]).{8,16}$"
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        
        return predicate.evaluate(with: self)
    }
    
    
}
