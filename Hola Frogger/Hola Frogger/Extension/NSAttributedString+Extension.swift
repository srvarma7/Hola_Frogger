//
//  NSAttributedString+Extension.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 27/10/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import Foundation

extension NSAttributedString {
    
    static func makeHyperLink(url: String, string: String, substring: String) -> NSAttributedString {
        
        let nsString = NSString(string: string)
        let subStringRange = nsString.range(of: substring)
        
        let attString = NSMutableAttributedString(string: string)
        attString.addAttribute(.link, value: url, range: subStringRange)
        
        return attString
    }
    
}

extension NSMutableAttributedString {

    public func setAsLink(textToFind:String, linkURL:String) -> Bool {

        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}
