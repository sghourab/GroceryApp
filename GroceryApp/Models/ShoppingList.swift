//
//  Shopping LIst.swift
//  GroceryApp
//
//  Created by Summer Crow on 2019-04-04.
//  Copyright © 2019 Mohammad Azam. All rights reserved.
//

import Foundation
typealias JSONDictionary = [String:Any]

class ShoppingList: Codable {
    var title: String!
    var groceryItems: [GroceryItem] = [GroceryItem]()
    
    init(title: String){
        self.title = title
    }
    init?(dictionary: [String:Any]) {
        guard let title = dictionary["title"] as? String else {
            return nil
        }
        self.title = title
    
        let groceryItemsDictionary = dictionary["groceryItems"] as? [JSONDictionary]
        
        if let dictionaries = groceryItemsDictionary{
            groceryItems = dictionaries.compactMap(GroceryItem.init)
        }
    }
    
   
    
//    func toDictionary() -> [String:Any]{
//    
//        return ["title":self.title, "groceryItems":groceryItems.map {
//            groceryItem in
//            return groceryItem.toDictionary()
//            }]
//        
//        
//    }
}
