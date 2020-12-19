//
//  SamplePlistManager.swift
//  Woomool
//
//  Created by Dustin on 2020/12/06.
//  Copyright © 2020 Woomool. All rights reserved.
//

import Foundation

class SamplePlistManager : NSObject {
    
    var namesPlist : NSMutableDictionary? = nil;
    
    static let Shared = SamplePlistManager();
    
    func loadFile(plistFileName: String)
    {
        let path : String = "\(Bundle.main.bundlePath)/";
        let finalPath = path.appending(plistFileName);
        
        self.namesPlist = NSMutableDictionary.init(contentsOfFile: finalPath);
    }
    
    func getValue(key: String) -> NSDictionary
    {
        if( self.namesPlist == nil )
        {
            self.loadFile(plistFileName: Define.DEF_DEFAULT_PLIST);
        }
        
        if( self.namesPlist?[key] == nil )
        {
            let tempMsg : String = "Error : 없는 키 \(key) 접근";
            
            return [:];
        }
        
        return self.namesPlist![key] as! NSDictionary;
    }
}
