//
//  Encodable+Extensions.swift
//  GroceryApp
//
//  Created by Summer Crow on 2019-04-15.
//  Copyright © 2019 Mohammad Azam. All rights reserved.
//

import Foundation

extension Encodable {
    
    func toDictionary() throws -> [String:Any] {
        var dictionary = [String:Any]()
        do {
            let data = try JSONEncoder().encode(self)
            guard let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] else {
                throw NSError()
            }
            dictionary = dict
        }
        return dictionary
    }
    
    
}
