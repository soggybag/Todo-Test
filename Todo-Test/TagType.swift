//
//  TagType.swift
//  Todo-Test
//
//  Created by mitchell hudson on 11/17/15.
//  Copyright © 2015 mitchell hudson. All rights reserved.
//

import UIKit

enum TagType: Int {
    case Tag1
    case Tag2
    case Tag3
    
    func toString() -> String {
        switch self {
        case .Tag1 :
            return "A"
            
        case .Tag2 :
            return "B"
            
        case .Tag3 :
            return "C"
        }
    }
    
    func tagColor() -> UIColor {
        switch self {
        case .Tag1 :
            return UIColor(red: 230/255, green: 35/255, blue: 123/255, alpha: 1)
            
        case .Tag2 :
            return UIColor.redColor()
            
        case .Tag3 :
            return UIColor.orangeColor()
        }
    }
}




