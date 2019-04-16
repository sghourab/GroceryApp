//
//  Grocery List.swift
//  GroceryApp
//
//  Created by Summer Crow on 2019-04-04.
//  Copyright © 2019 Mohammad Azam. All rights reserved.
//

import Foundation

class GroceryItem: Codable {
    
    var title: String
    
    init(title: String){
        self.title = title
    }
    
    init?(dictionary: JSONDictionary){
        guard let title = dictionary["title"] as? String else {
            return nil
        }
        self.title = title
    }
    
//    func toDictionary() -> [String:Any]{
//        
//        return ["title":self.title]
//        
//    }
    
}
