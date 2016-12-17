//
//  UtilitiesFunctions.swift
//  Music Library
//
//  Created by Hari Krishna Bista on 12/17/16.
//  Copyright © 2016 meroApp. All rights reserved.
//

import UIKit

class UtilitiesFunctions {
    
    static func removeWhiteSpaceByPlus(input:String) -> String {
        let arr = input.components(separatedBy: " ")
        var tempText = "";
        
        for tmp in arr {
            tempText = tempText + "+" + tmp.trimmingCharacters(in: .whitespaces);
        }
        return tempText;
    }
    
    static func stringByReplacingFirstOccurrenceOfString(target: String,byStr:String, withStr:String)-> String{
        return target.replacingCharacters(in: target.range(of: byStr)!, with: withStr);
    }

}
