//
//  String+Extension.swift
//  GroceryApp
//
//  Created by Summer Crow on 2019-04-15.
//  Copyright © 2019 Mohammad Azam. All rights reserved.
//

import Foundation

extension String {
    
    func removeSpecialCharacters() -> String {
        
        return self.components(separatedBy: CharacterSet.letters.inverted).joined()
        
    }
    
}
